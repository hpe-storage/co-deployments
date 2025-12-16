# Set these
VERSION ?= 0.0.0
SOURCE_VERSION ?= $(VERSION)
REPO_NAME ?= quay.io/myrepo
# Do not use < 1.38.0
OPERATOR_SDK_TAG = v1.38.0-ocp
OPERATOR_SDK = 'operator-sdk version: "$(OPERATOR_SDK_TAG)"'

# Don't set these, preferably
RH_REPO_NAME=registry.connect.redhat.com/hpestorage
COMMUNITY_OUTPUT=destinations/community-operators/current-version
COMMUNITY_DISPLAY_NAME=HPE CSI Operator for Kubernetes
CERTIFIED_OUTPUT=destinations/certified-operators/current-version
CERTIFIED_DISPLAY_NAME=HPE CSI Operator for OpenShift
NAMESPACE ?= hpe-storage
CHART ?= hpe-csi-driver
VANITY_NAME ?= hpe-csi-operator
IMAGE_NAME ?= csi-driver-operator
BUNDLE_NAME ?= csi-driver-operator-bundle
OCP_BUNDLE_NAME ?= csi-driver-operator-bundle-ocp
IMG ?= $(REPO_NAME)/$(IMAGE_NAME):v$(VERSION)
BUNDLE_IMG ?= $(REPO_NAME)/$(BUNDLE_NAME):v$(VERSION)
OCP_BUNDLE_IMG ?= $(REPO_NAME)/$(OCP_BUNDLE_NAME):v$(VERSION)
BUNDLE_CHANNELS ?= stable
PLATFORMS ?= linux/arm64,linux/amd64
OPERATOR_SDK_IMG_NAME ?= helm-operator
OPERATOR_SDK_URL ?= $(REPO_NAME)/$(OPERATOR_SDK_IMG_NAME):$(OPERATOR_SDK_TAG)

undeploy:
	# Remove Operator from cluster
	- operator-sdk cleanup $(VANITY_NAME) -n $(NAMESPACE)

clean: undeploy
	# Delete build
	rm -rf "operator-sdk" "init" "prep" "$(IMAGE_NAME)" bundle-*

init:
	# Ensure specific version of Operator SDK
	operator-sdk version | grep $(OPERATOR_SDK)

	# Creat temp space
	mkdir $(IMAGE_NAME)

	# Initialize workspace
	cd $(IMAGE_NAME); operator-sdk init --plugins helm.sdk.operatorframework.io/v1 \
       		--domain hpe.com \
		--group storage \
		--version v1 \
		--kind HPECSIDriver \
		--project-name $(VANITY_NAME) \
                --helm-chart ../../../docs/$(CHART)-$(VERSION).tgz \
                --helm-chart-version $(SOURCE_VERSION)

        # Build & push our base Helm Operator with latest UBI images
	git clone https://github.com/operator-framework/operator-sdk
	cd operator-sdk; git checkout $(OPERATOR_SDK_TAG); docker-buildx build --progress=plain --no-cache \
	--provenance=false --push --platform=$(PLATFORMS) --tag $(OPERATOR_SDK_URL) -f images/helm-operator/Dockerfile \
	--build-arg https_proxy=$(https_proxy) --build-arg http_proxy=$(http_proxy) --build-arg no_proxy=$(no_proxy) \
	.

	# Mark complete
	touch init

prep: init
	# Populate with our sources
	mkdir -p $(IMAGE_NAME)/config/manifests/bases
	cp -f sources/hpecsidrivers.storage.hpe.com.crd.yaml \
		$(IMAGE_NAME)/config/crd/bases/storage.hpe.com_hpecsidrivers.yaml
	sed -e "s/%SEMVER%/$(VERSION)/g" -e "s#%IMG%#$(IMG)#g" \
		sources/hpe-csi-operator.csv.yaml \
		> $(IMAGE_NAME)/config/manifests/bases/hpe-csi-operator.clusterserviceversion.yaml
	cp -f sources/role.yaml $(IMAGE_NAME)/config/rbac/

	# Fix memory on the manager.
	sed -i.remove -e "s/memory: 128Mi/memory: 1Gi/g" $(IMAGE_NAME)/config/manager/manager.yaml && \
		rm -f $(IMAGE_NAME)/config/manager/manager.yaml.remove
	
	# Dockerfile for operator
	sed -e "s|%FROM%|FROM $(OPERATOR_SDK_URL)|" sources/operator.Dockerfile > $(IMAGE_NAME)/Dockerfile
	sed -i.remove -e "s/%SEMVER%/$(VERSION)/g" $(IMAGE_NAME)/Dockerfile && \
		rm -f $(IMAGE_NAME)/Dockerfile.remove
	cp -f sources/LICENSE $(IMAGE_NAME)/LICENSE

	# Community and OpenShift Operators
	cd $(IMAGE_NAME); docker-buildx build --progress=plain --no-cache \
	--provenance=false --push --platform=$(PLATFORMS) --tag ${IMG} -f Dockerfile .

	# Sample CSI driver instance
	cp -f $(IMAGE_NAME)/config/samples/storage_v1_hpecsidriver.yaml \
		destinations/hpecsidriver-v${VERSION}-sample.yaml
	cp -f $(IMAGE_NAME)/config/samples/storage_v1_hpecsidriver.yaml \
		destinations/hpecsidriver-latest-sample.yaml
	touch prep

community: prep
	# Create community bundle manifests
	cd $(IMAGE_NAME); make bundle CHANNELS=$(BUNDLE_CHANNELS) IMG="$(IMG)" BUNDLE_IMG="$(BUNDLE_IMG)" VERSION="$(VERSION)" USE_IMAGE_DIGESTS="true"

	# Dockerfile for community bundle
	sed -i.remove -e "s/^FROM.*//g" $(IMAGE_NAME)/bundle.Dockerfile && \
		rm -f $(IMAGE_NAME)/bundle.Dockerfile.remove
	cat sources/bundle.Dockerfile $(IMAGE_NAME)/bundle.Dockerfile \
		> $(IMAGE_NAME)/bundle.Dockerfile-tmp && \
		mv $(IMAGE_NAME)/bundle.Dockerfile-tmp $(IMAGE_NAME)/bundle.Dockerfile

	# Annotations for community bundle
	cat sources/annotations.community.yaml | tee -a $(IMAGE_NAME)/bundle/metadata/annotations.yaml

	# Create community bundle image for testing
	cd $(IMAGE_NAME); make bundle-build bundle-push IMG="$(IMG)" BUNDLE_IMG="$(BUNDLE_IMG)" VERSION="$(VERSION)" USE_IMAGE_DIGESTS="true"

        # Validate community bundle
	operator-sdk bundle validate $(BUNDLE_IMG) --select-optional suite=operatorframework

	# Create community-operators content
	rm -rf $(COMMUNITY_OUTPUT)/*
	cp -f -a $(IMAGE_NAME)/bundle/* $(COMMUNITY_OUTPUT)
	mv $(COMMUNITY_OUTPUT)/manifests/hpe-csi-operator.clusterserviceversion.yaml \
		$(COMMUNITY_OUTPUT)/manifests/hpe-csi-operator.v$(VERSION).clusterserviceversion.yaml
		cp -f $(IMAGE_NAME)/bundle.Dockerfile $(COMMUNITY_OUTPUT)/Dockerfile

community-deploy:
	# Run community bundle
	- kubectl create ns $(NAMESPACE)
	operator-sdk run bundle --timeout 5m $(BUNDLE_IMG) -n $(NAMESPACE)

	# Instantiate HPECSIDriver
	kubectl apply -n $(NAMESPACE) -f destinations/hpecsidriver-v${VERSION}-sample.yaml

community-scorecard:
	# Create community scorecard
	operator-sdk scorecard --wait-time 5m $(BUNDLE_IMG) -n $(NAMESPACE)

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
	operator-sdk bundle validate $(OCP_BUNDLE_IMG) --select-optional suite=operatorframework

	# Create certified-operators content
	rm -rf $(CERTIFIED_OUTPUT)/*
	cp -f -a $(IMAGE_NAME)/bundle/* $(CERTIFIED_OUTPUT)
	sed -i.remove -e "s|$(REPO_NAME)/$(IMAGE_NAME)|$(RH_REPO_NAME)/$(IMAGE_NAME)|g" -e "/replaces: /d" \
		$(CERTIFIED_OUTPUT)/manifests/hpe-csi-operator.clusterserviceversion.yaml && \
		rm -f $(CERTIFIED_OUTPUT)/manifests/hpe-csi-operator.clusterserviceversion.yaml.remove

	# Rename certified display name
	sed -i.remove -e "s/$(COMMUNITY_DISPLAY_NAME)/$(CERTIFIED_DISPLAY_NAME)/g" \
		$(CERTIFIED_OUTPUT)/manifests/hpe-csi-operator.clusterserviceversion.yaml && \
		rm -f $(CERTIFIED_OUTPUT)/manifests/hpe-csi-operator.clusterserviceversion.yaml.remove

certified-deploy:
	# Run certified bundle
	- oc create ns $(NAMESPACE)
	operator-sdk run bundle --security-context-config=restricted --timeout 5m $(OCP_BUNDLE_IMG) -n $(NAMESPACE)

	# Instantiate HPECSIDriver
	oc apply -n $(NAMESPACE) -f destinations/hpecsidriver-v${VERSION}-sample.yaml

certified-scorecard:
	# Create certified scorecard
	operator-sdk scorecard --wait-time 5m $(OCP_BUNDLE_IMG) -n $(NAMESPACE)
