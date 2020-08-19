#!/bin/bash

# bail out on errors
set -xe

# images
REPO_NAME=${REPO_NAME:-hpestorage}
HPE_CSI_OPERATOR_IMAGE=${HPE_CSI_OPERATOR_IMAGE:-csi-driver-operator}
HPE_CSI_OPERATOR_TAG=${HPE_CSI_OPERATOR_TAG:-edge}

# stage directory for build
IMG_DIR=$(dirname $0)
HELM_DIR=${IMG_DIR}/../../helm
mkdir -p ${IMG_DIR}/helm-charts

cp ${IMG_DIR}/../../LICENSE ${IMG_DIR}/

# Cleanup and Copy helm charts to staging directory
rm -rf ${IMG_DIR}/helm-charts
cp -r ${HELM_DIR}/charts/hpe-csi-driver ${IMG_DIR}/helm-charts

# build an operator
docker build -t ${REPO_NAME}/${HPE_CSI_OPERATOR_IMAGE}:${HPE_CSI_OPERATOR_TAG} ${IMG_DIR}
