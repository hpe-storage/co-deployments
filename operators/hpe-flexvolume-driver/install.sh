#!/bin/bash
IMAGE=hpestorage/flexvolume-driver-operator:edge
NAMESPACE=hpe-flexvolume
KUBECTL=kubectl
FLAVOR=k8s
SVC_ACCNT_FLEXVOLUME=hpe-flexvolume-sa
valid_flavor=0
declare -a flavors=("k8s" "eks" "aks" "ocp" "rke" "gke" "gkeop")

usage()
{
    echo "Usage : $0 --image=<imagename> --namespace=<namespace> --flavor=<co flavor> --values=<values.yaml file path>"
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
    exit
fi

while (("$#")); do
case "$1" in
  --image=*)
  IMAGE="${1#*=}"
  shift
  ;;
  --namespace=*)
  NAMESPACE="${1#*=}"
  shift
  ;;
  --flavor=*)
  FLAVOR="${1#*=}"
  if [[ "${FLAVOR}" == "ocp" || "${FLAVOR}" == "openshift" ]]; then
      KUBECTL=oc
  else
      # validate for supported co flavors
      for val in ${flavors[@]}; do
        if [[ "${FLAVOR}" == "$val" ]]; then
            valid_flavor=1
            break
        fi
      done
      if [[ $valid_flavor -ne 1 ]]; then
        echo "flavor can only be 'k8s' 'ocp', 'eks', 'aks', 'rke', 'gke' or 'gkeop'"
        usage
        exit
      fi
  fi
  shift
  ;;
  --values=*)
  VALUESFILE="${1#*=}"
  shift
  ;;
  -h|--help|*)
  usage
  exit
  ;;
  esac
done

if [[ -z ${VALUESFILE} || ! -f ${VALUESFILE} ]]; then
    echo "File ${VALUESFILE} does not exist"
    usage
    exit 1
fi

KUBECTL_NS="${KUBECTL} apply -n ${NAMESPACE} -f"

# 1. Create the namespace
if [[ "${KUBECTL}" == "kubectl" ]]; then
    $KUBECTL create namespace ${NAMESPACE}
else
    $KUBECTL adm new-project ${NAMESPACE}

    # Since this plugin needs to mount external volumes to containers, create a SCC to allow the hpe csi pods to
    # use the hostPath volume plugin
    cat deploy/scc.yaml | $KUBECTL create -f -

    # Grant this SCC to the service account creating the flexvolume driver
    $KUBECTL adm policy add-scc-to-user hpe-flexvolume-scc -n ${NAMESPACE} -z ${SVC_ACCNT_FLEXVOLUME}
fi

# 2. Create CRD and wait until TIMEOUT seconds for the CRD to be established.
try=0
MAX_RETRIES=10
cat deploy/crd.yaml | ${KUBECTL} apply -f -

while true; do
  result=$(${KUBECTL} get crd/hpeflexvolumedrivers.storage.hpe.com -o jsonpath='{.status.conditions[?(.type == "Established")].status}{"\n"}' | grep -i true)
  if [ $? -eq 0 ]; then
     break
  fi
  try=$(($try+1))
  if [ $try -gt $MAX_RETRIES ]; then
     break
  fi
  sleep 1
done

if [ $try -gt $MAX_RETRIES ]; then
   echo "Timed out waiting for creation of crd/hpeflexvolumedrivers.storage.hpe.com"
   exit 1
fi

# 3. Create RBAC for the HPE FlexVolume Operator
cat deploy/rbac.yaml | sed "s|REPLACE_NAMESPACE|${NAMESPACE}|" | ${KUBECTL_NS} -

# 4. Create a HPE FlexVolume Operator Deployment
cat deploy/operator.yaml| sed "s|REPLACE_IMAGE|${IMAGE}|" | ${KUBECTL_NS} -

# 5. Use the values.yaml file to create a customized HPE FlexVolume operator instance
(cat deploy/cr.yaml | sed "s|REPLACE_NAMESPACE|${NAMESPACE}|"; sed 's/.*/  &/' ${VALUESFILE} | sed "s/flavor:.*/flavor: ${FLAVOR}/") | ${KUBECTL_NS} -