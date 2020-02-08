#!/bin/bash

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

# Delete the HPE CSI Driver custom resource, this will cause our CSI plugin resources to be cleaned up.
$KUBECTL delete hpecsidrivers/hpecsidriver-operator -n $NAMESPACE
$KUBECTL delete crd hpecsidrivers.storage.hpe.com

# Delete all cluster level roles and bindings for operator
$KUBECTL delete clusterrole hpe-csi-operator
$KUBECTL delete clusterrolebinding hpe-csi-operator-role
$KUBECTL delete role hpe-csi-operator -n $NAMESPACE
$KUBECTL delete rolebinding default-account-hpe-csi-operator -n $NAMESPACE
$KUBECTL delete scc hpe-csi-scc

# Delete operator deployment itself
$KUBECTL delete deployment hpe-csi-operator -n $NAMESPACE
