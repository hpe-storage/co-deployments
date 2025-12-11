# Set these
VERSION ?= 0.0.0
SOURCE_VERSION ?= $(VERSION)
REPO_NAME ?= quay.io/myrepo

# Don't set these, preferably
OPERATOR_SDK ?= operator-sdk
RH_REPO_NAME=registry.connect.redhat.com/hpestorage
CERTIFIED_OUTPUT=destinations/certified-operators/current-version
NAMESPACE ?= hpe-storage
KIND ?= HPEGreenLakeFileCSIDriver
KIND_LC ?= hpegreenlakefilecsidriver
CHART ?= hpe-greenlake-file-csi-driver
VANITY_NAME ?= hpe-filex-csi-operator
IMAGE_NAME ?= filex-csi-driver-operator
OCP_BUNDLE_NAME ?= filex-csi-driver-operator-bundle-ocp
IMG ?= $(REPO_NAME)/$(IMAGE_NAME):v$(VERSION)
OCP_BUNDLE_IMG ?= $(REPO_NAME)/$(OCP_BUNDLE_NAME):v$(VERSION)
BUNDLE_CHANNELS ?= stable
PLATFORMS ?= linux/amd64
#PLATFORMS ?= linux/arm64,linux/amd64

undeploy:
	# Remove Operator from cluster
	- $(OPERATOR_SDK) cleanup $(VANITY_NAME) -n $(NAMESPACE)

clean: undeploy
	# Delete build
	rm -rf "init" "prep" "$(IMAGE_NAME)" bundle-*

init:
	# Creat temp space
	mkdir $(IMAGE_NAME)

	# Initialize workspace
	cd $(IMAGE_NAME); $(OPERATOR_SDK) init --plugins helm.sdk.operatorframework.io/v1 \
       		--domain hpe.com \
		--group storage \
		--version v1 \
		--kind $(KIND) \
		--project-name $(VANITY_NAME) \
		--helm-chart ../../../docs/$(CHART)-$(VERSION).tgz \
	        --helm-chart-version $(SOURCE_VERSION)
	touch init

prep: init
	# Populate with our sources
	mkdir -p $(IMAGE_NAME)/config/manifests/bases
	cp -f sources/$(KIND_LC)s.storage.hpe.com.crd.yaml \
		$(IMAGE_NAME)/config/crd/bases/storage.hpe.com_$(KIND_LC)s.yaml
	sed -e "s/%SEMVER%/$(VERSION)/g" -e "s#%IMG%#$(IMG)#g" \
		sources/$(VANITY_NAME).csv.yaml \
		> $(IMAGE_NAME)/config/manifests/bases/$(VANITY_NAME).clusterserviceversion.yaml
	cp -f sources/role.yaml $(IMAGE_NAME)/config/rbac/

	# Fix memory on the manager.
	sed -i.remove -e "s/memory: 128Mi/memory: 1Gi/g" $(IMAGE_NAME)/config/manager/manager.yaml && \
		rm -f $(IMAGE_NAME)/config/manager/manager.yaml.remove

	# Dockerfile for operator
	sed -e "s|%FROM%|$(shell grep ^FROM $(IMAGE_NAME)/Dockerfile)|" sources/operator.Dockerfile > $(IMAGE_NAME)/Dockerfile
	sed -i.remove -e "s/%SEMVER%/$(VERSION)/g" $(IMAGE_NAME)/Dockerfile && \
		rm -f $(IMAGE_NAME)/Dockerfile.remove
	cp -f sources/LICENSE $(IMAGE_NAME)/LICENSE

	# Community and OpenShift Operators
	cd $(IMAGE_NAME); docker-buildx build --progress=plain --no-cache \
	--provenance=false --push --platform=$(PLATFORMS) --tag ${IMG} -f Dockerfile .

	# Sample CSI driver instance
	cp -f $(IMAGE_NAME)/config/samples/storage_v1_$(KIND_LC).yaml \
		destinations/$(KIND_LC)-v${VERSION}-sample.yaml
	cp -f $(IMAGE_NAME)/config/samples/storage_v1_$(KIND_LC).yaml \
		destinations/$(KIND_LC)-latest-sample.yaml
	touch prep

certified: prep
	# Create certified bundle manifests
	cd $(IMAGE_NAME); make bundle CHANNELS="$(BUNDLE_CHANNELS)" IMG="$(IMG)" BUNDLE_IMG="$(OCP_BUNDLE_IMG)" VERSION="$(VERSION)" USE_IMAGE_DIGESTS="true"

	# Dockerfile for certified bundle
	sed -i.remove -e "s/^FROM.*//g" $(IMAGE_NAME)/bundle.Dockerfile && \
		rm -f $(IMAGE_NAME)/bundle.Dockerfile.remove
	cat sources/bundle.Dockerfile $(IMAGE_NAME)/bundle.Dockerfile \
		> $(IMAGE_NAME)/bundle.Dockerfile-tmp && \
		mv $(IMAGE_NAME)/bundle.Dockerfile-tmp $(IMAGE_NAME)/bundle.Dockerfile

	# Annotations for certified bundle
	cat sources/annotations.certified.yaml | tee -a $(IMAGE_NAME)/bundle/metadata/annotations.yaml

	# Create certified bundle image for testing
	cd $(IMAGE_NAME); make bundle-build bundle-push IMG="$(IMG)" BUNDLE_IMG="$(OCP_BUNDLE_IMG)" VERSION="$(VERSION)" USE_IMAGE_DIGESTS="true"

        # Validate certified bundle
	$(OPERATOR_SDK) bundle validate $(OCP_BUNDLE_IMG) --select-optional suite=operatorframework

	# Create certified-operators content
	rm -rf $(CERTIFIED_OUTPUT)/*
	cp -f -a $(IMAGE_NAME)/bundle/* $(CERTIFIED_OUTPUT)
	sed -i.remove -e "s|$(REPO_NAME)/$(IMAGE_NAME)|$(RH_REPO_NAME)/$(IMAGE_NAME)|g" -e "/replaces: /d" \
		$(CERTIFIED_OUTPUT)/manifests/$(VANITY_NAME).clusterserviceversion.yaml && \
		rm -f $(CERTIFIED_OUTPUT)/manifests/$(VANITY_NAME).clusterserviceversion.yaml.remove

certified-deploy:
	# Run certified bundle
	- oc create ns $(NAMESPACE)
	$(OPERATOR_SDK) run bundle --timeout 5m $(OCP_BUNDLE_IMG) -n $(NAMESPACE)

	# Instantiate HPECSIDriver
	oc apply -n $(NAMESPACE) -f destinations/$(KIND_LC)-v${VERSION}-sample.yaml

certified-scorecard:
	# Create certified scorecard
	$(OPERATOR_SDK) scorecard --wait-time 5m $(OCP_BUNDLE_IMG) -n $(NAMESPACE)
