#!/bin/bash
IMAGE=hpestorage/csi-driver-operator:edge
NAMESPACE=hpe-csi
KUBECTL=kubectl
FLAVOR=k8s
SVC_ACCNT_CONTROLLER=hpe-csi-controller-sa
SVC_ACCNT_NODE=hpe-csi-node-sa
SVC_ACCNT_CSP=hpe-csp-sa

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
  if [[ "${FLAVOR}" == "k8s" || "${FLAVOR}" == "kubernetes" ]]; then
      KUBECTL=kubectl
  elif [[ "${FLAVOR}" == "ocp" || "${FLAVOR}" == "openshift" ]]; then
      KUBECTL=oc
  else
      echo "flavor can only be 'kubernetes' 'k8s' 'ocp' or 'openshift'"
      usage
      exit
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

    # Grant this SCC to the service account creating the csi driver
    $KUBECTL adm policy add-scc-to-user hpe-csi-scc -n ${NAMESPACE} -z ${SVC_ACCNT_CONTROLLER}
    $KUBECTL adm policy add-scc-to-user hpe-csi-scc -n ${NAMESPACE} -z ${SVC_ACCNT_NODE}
    $KUBECTL adm policy add-scc-to-user hpe-csi-scc -n ${NAMESPACE} -z ${SVC_ACCNT_CSP}
fi

# 2. Create CRD and wait until TIMEOUT seconds for the CRD to be established.
try=0
MAX_RETRIES=10
cat deploy/crd.yaml | ${KUBECTL} apply -f -

while true; do
  result=$(${KUBECTL} get crd/hpecsidrivers.storage.hpe.com -o jsonpath='{.status.conditions[?(.type == "Established")].status}{"\n"}' | grep -i true)
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
   echo "Timed out waiting for creation of crd/hpecsidrivers.storage.hpe.com"
   exit 1
fi

# 3. Create RBAC for the HPE CSI Operator
cat deploy/rbac.yaml | sed "s|REPLACE_NAMESPACE|${NAMESPACE}|" | ${KUBECTL_NS} -

# 4. Create a HPE CSI Operator Deployment
cat deploy/operator.yaml| sed "s|REPLACE_IMAGE|${IMAGE}|" | ${KUBECTL_NS} -

# 5. Use the values.yaml file to create a customized HPE CSI operator instance
(cat deploy/cr.yaml | sed "s|REPLACE_NAMESPACE|${NAMESPACE}|"; sed 's/.*/    &/' ${VALUESFILE}) | ${KUBECTL_NS} -