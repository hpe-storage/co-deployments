FROM quay.io/operator-framework/helm-operator:v0.10.0
MAINTAINER hpe-containers-dev@hpe.com
LABEL name="hpe-csi-operator" vendor="HPE" version="1.0.0" release="1.0" summary="HPE CSI Operator" description="HPE CSI Driver Operator"
COPY helm-charts/ ${HOME}/helm-charts/
COPY watches.yaml ${HOME}/watches.yaml
