FROM quay.io/operator-framework/helm-operator:v0.15.1
LABEL name="csi-driver-operator" \
      maintainer="HPE Storage" \
      vendor="HPE" \
      version="1.0.0" \
      release="1.0" \
      summary="HPE CSI Operator" \
      description="HPE CSI Driver Operator" \
      io.k8s.display-name="HPE CSI Driver Operator for Kubernetes" \
      io.k8s.description="The HPE CSI Driver Operator for Kubernetes enables container orchestrators, such as Kubernetes and OpenShift, to manage the life-cycle of persistent storage." \
      io.openshift.tags=hpe,csi,hpe-csi-driver

COPY helm-charts/ ${HOME}/helm-charts/
COPY watches.yaml ${HOME}/watches.yaml
COPY LICENSE /licenses/
