#!/usr/bin/env bash

# exit on failures
set -xe

if [ $# -ne 1 ]; then
    echo "Usage: package.sh <chart-name>"
    exit 1
fi

CHART_BASE_DIR=$(dirname $0)
CHART_NAME=$1
cd ${CHART_BASE_DIR}

echo "Linting chart ${CHART_NAME}"
helm lint ${CHART_NAME}
echo "Packaging ${CHART_NAME}..."
helm package ${CHART_NAME} -d ${CHART_BASE_DIR}/../../docs
echo "Generating index file under docs/"
helm repo index ${CHART_BASE_DIR}/../../docs
echo "Successfully generated chart for $1 and updated docs/index.yaml"
