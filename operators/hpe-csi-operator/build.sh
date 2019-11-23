#!/bin/bash

# bail out on errors
set -xe

# images
REPO_NAME=${REPO_NAME:-quay.io/hpestorage}
HPE_CSI_OPERATOR_IMAGE=${HPE_CSI_OPERATOR_IMAGE:-hpe-csi-operator}
HPE_CSI_OPERATOR_TAG=${HPE_CSI_OPERATOR_TAG:-latest}

# stage directory for build
IMG_DIR=$(dirname $0)
HELM_DIR=${IMG_DIR}/../../helm
mkdir -p ${IMG_DIR}/helm-charts

# Copy helm charts to staging directory
cp -r ${HELM_DIR}/charts/hpe-csi-driver ${IMG_DIR}/helm-charts

# build an operator
docker build -t ${REPO_NAME}/${HPE_CSI_OPERATOR_IMAGE}:${HPE_CSI_OPERATOR_TAG} ${IMG_DIR}
