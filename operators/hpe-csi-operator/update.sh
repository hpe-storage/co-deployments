#!/bin/bash
# update hpe csi driver

usage()
{
    echo "Usage : $0 -f <values.yaml>"
    exit
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
fi

while (("$#")); do
case "$1" in
  -f)
  if [ "$#" -lt 2 ]; then
    usage
    exit
  fi
  VALUESFILE="$2"
  shift
  shift
  ;;
  -h|--help|*)
  usage
  exit
  ;;
  esac
done

if [[ -z ${VALUESFILE} || ! -f ${VALUESFILE} ]]; then
    usage
    echo "File ${VALUESFILE} for values.yaml does not exist"
    exit 1
fi

# Find out if this is OpenShift

OC=/usr/bin/oc

if [ -f "$OC" ]; then
  KUBECTL=oc
  FLAVOR=openshift
else
  KUBECTL=kubectl
  FLAVOR=k8s
fi

# Discover which namespace we have installed HPE CSI Driver in

NAMESPACE=`$KUBECTL get daemonset --all-namespaces | grep hpe-csi | awk '{print $1}' -`
if [ -z $NAMESPACE ]; then
  echo "Error: Failed to get namespace for hpe csi driver"
  exit 1
fi

# Discover the image we are currently using

IMAGE=`$KUBECTL describe deployment hpe-csi-operator -n $NAMESPACE | grep Image | awk '{print $2}' -`
if [ -z $IMAGE ]; then
  echo "Error: Failed to identify image being used for hpe-csi operator"
  exit 1
fi

# Reinstall HPE CSI Driver Operator

./install.sh --image=$IMAGE --namespace=$NAMESPACE --flavor=$FLAVOR --values=$VALUESFILE > /dev/null 2>&1

$KUBECTL rollout status deployment/hpe-csi-controller -n $NAMESPACE
$KUBECTL rollout status daemonset/hpe-csi-node -n $NAMESPACE

