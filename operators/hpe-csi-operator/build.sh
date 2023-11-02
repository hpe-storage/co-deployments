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
rm -rf ${IMG_DIR}/helm-charts
mkdir -p ${IMG_DIR}/helm-charts

cp ${IMG_DIR}/../../LICENSE ${IMG_DIR}/

# Copy helm charts to staging directory
cp -r ${HELM_DIR}/charts/hpe-csi-driver ${IMG_DIR}/helm-charts

# build an operator
docker-buildx build --platform=linux/amd64,linux/arm64 --progress=plain \
	--build-arg=https_proxy=${https_proxy} \
        --build-arg=http_proxy=${http_proxy} \
	--provenance=false --push \
	${1} -t ${REPO_NAME}/${HPE_CSI_OPERATOR_IMAGE}:${HPE_CSI_OPERATOR_TAG} ${IMG_DIR}
