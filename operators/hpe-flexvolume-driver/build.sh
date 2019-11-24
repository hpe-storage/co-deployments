#!/bin/bash

# bail out on errors
set -xe

# images
REPO_NAME=${REPO_NAME:-hpestorage}
HPE_FLEXVOLUME_OPERATOR_IMAGE=${HPE_FLEXVOLUME_OPERATOR_IMAGE:-flexvolume-driver-operator}
HPE_FLEXVOLUME_OPERATOR_TAG=${HPE_FLEXVOLUME_OPERATOR_TAG:-edge}

# stage directory for build
IMG_DIR=$(dirname $0)
HELM_DIR=${IMG_DIR}/../../helm
mkdir -p ${IMG_DIR}/helm-charts

# Copy helm charts to staging directory
cp -r ${HELM_DIR}/charts/hpe-flexvolume-driver ${IMG_DIR}/helm-charts

# build an operator
docker build -t ${REPO_NAME}/${HPE_FLEXVOLUME_OPERATOR_IMAGE}:${HPE_FLEXVOLUME_OPERATOR_TAG} ${IMG_DIR}
