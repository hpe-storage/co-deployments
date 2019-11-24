FROM quay.io/operator-framework/helm-operator:v0.10.1
LABEL name="flexvolume-driver-operator" vendor="HPE" version="1.0.0" release="1.0" summary="HPE FlexVolume Operator" description="HPE FlexVolume Driver Operator"
COPY helm-charts/ ${HOME}/helm-charts/
COPY watches.yaml ${HOME}/watches.yaml
