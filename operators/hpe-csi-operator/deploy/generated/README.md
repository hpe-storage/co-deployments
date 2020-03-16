### Generation of HPECSIDriver CRD
Follow steps from https://book.kubebuilder.io/quick-start.html to create a sample project and generate HPECSIDriver CRD using kube-builder and copying files from this folder.

Install kubebuilder:
```
os=$(go env GOOS)
arch=$(go env GOARCH)

# download kubebuilder and extract it to tmp
curl -L https://go.kubebuilder.io/dl/2.3.0/${os}/${arch} | tar -xz -C /tmp/

# move to a long-term location and put it on your path
# (you'll need to set the KUBEBUILDER_ASSETS env var if you put it somewhere else)
sudo mv /tmp/kubebuilder_2.3.0_${os}_${arch} /usr/local/kubebuilder
export PATH=$PATH:/usr/local/kubebuilder/bin
```

Create a sample Project:
```
mkdir $GOPATH/src/hpe-csi-driver
export GO111MODULE=on
cd $GOPATH/src/hpe-csi-driver
kubebuilder init --domain storage.hpe.com
```

Create an API:
```
kubebuilder create api --group storage.hpe.com --version v1 --kind HPECSIDriver
```

files will be generated under api/v1/. Replace files generated under api/v1 from current folder, modify hpecsidriver_types.go as required to add any fields and run `make manifests` to generate HPECSIDriver CRD under `config/crd/bases/` folder. Copy the CRD to deploy/crds folder and create a CR for that instance.


### Generation of CSV bundle with each driver update:
New CSV and CRD can be generated using below command

```
cd operators/hpe-csi-driver-operator
operator-sdk generate csv --csv-channel hpestorage/csi-driver-operator --csv-version=1.1.0 --operator-name hpe-csi-driver-operator --from-version=1.0.0 --update-crds
```

A new folder will be generated as olm-catalog/1.1.0 which consist of CRD and new CSV files. This bundle can be used to run operator-scorecard tests and upload to OperatorHub.io.