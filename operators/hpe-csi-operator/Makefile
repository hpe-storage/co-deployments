# Set these
VERSION ?= 0.0.0
REPO_NAME ?= quay.io/datamattsson
BUILD_OCP ?=

# Don't set these
VANITY_NAME ?= hpe-csi-operator
IMAGE_NAME ?= csi-driver-operator
BUNDLE_NAME ?= csi-driver-operator-bundle
IMG ?= $(REPO_NAME)/$(IMAGE_NAME)
BUNDLE_IMG ?= $(REPO_NAME)/$(BUNDLE_NAME):v$(VERSION)
BUNDLE_CHANNELS ?= stable
PLATFORMS ?= linux/arm64,linux/amd64

clean:
	operator-sdk cleanup $(VANITY_NAME)
	test -f $(IMAGE_NAME) || rm -rf $(IMAGE_NAME)
init: clean
	# Creat temp space
	mkdir $(IMAGE_NAME)

	# Initialize workspace
	cd $(IMAGE_NAME); operator-sdk init --plugins helm.sdk.operatorframework.io/v1 \
       		--domain hpe.com \
		--group storage \
		--version v1 \
		--kind HPECSIDriver \
		--project-name hpe-csi-operator \
		--helm-chart=../../../helm/charts/hpe-csi-driver
build: init
	# Populate with our sources
	mkdir -p $(IMAGE_NAME)/config/manifests/bases
	cp sources/hpecsidrivers.storage.hpe.com.crd.yaml \
		$(IMAGE_NAME)/config/crd/bases/storage.hpe.com_hpecsidrivers.yaml
	sed -e "s/%SEMVER%/$(VERSION)/g" -e "s#%IMG%#$(IMG)#g" \
		sources/hpe-csi-operator.csv.yaml \
		> $(IMAGE_NAME)/config/manifests/bases/hpe-csi-operator.clusterserviceversion.yaml
	cp sources/role.yaml $(IMAGE_NAME)/config/rbac/

	# Fix memory on the manager.
	sed -i"" -e "s/memory: 128Mi/memory: 512Mi/g" $(IMAGE_NAME)/config/manager/manager.yaml

	# Build Operators
ifeq ($(BUILD_OCP),true)
	# Red Hat OpenShift
	cd $(IMAGE_NAME); make docker-build docker-push IMG="$(IMG)" VERSION="$(VERSION)" USE_IMAGE_DIGESTS="true" BUNDLE_CHANNELS="$(BUNDLE_CHANNELS)"
else
	# Community
	cd $(IMAGE_NAME); docker-buildx build --progress=plain \
	--provenance=false --push --platform=$(PLATFORMS) --tag ${IMG} -f Dockerfile .
endif
	# Create bundle manifests
	cd $(IMAGE_NAME); make bundle CHANNELS=$(BUNDLE_CHANNELS) IMG="$(IMG)" BUNDLE_IMG="$(BUNDLE_IMG)" VERSION="$(VERSION)" USE_IMAGE_DIGESTS="true"

	# Dockerfiles
	sed -e "s|%FROM%|$(shell grep ^FROM $(IMAGE_NAME)/Dockerfile)|" sources/operator.Dockerfile > $(IMAGE_NAME)/Dockerfile
	sed -i "" -e "s/%SEMVER%/$(VERSION)/g" $(IMAGE_NAME)/Dockerfile
	sed -i "" -e "s/^FROM.*//g" $(IMAGE_NAME)/bundle.Dockerfile
	cat sources/bundle.Dockerfile $(IMAGE_NAME)/bundle.Dockerfile \
		> $(IMAGE_NAME)/bundle.Dockerfile-tmp && \
		mv $(IMAGE_NAME)/bundle.Dockerfile-tmp $(IMAGE_NAME)/bundle.Dockerfile

	# Annotations
	cat sources/annotations.*.yaml | tee -a $(IMAGE_NAME)/bundle/metadata/annotations.yaml

	# Create bundle image for testing
	cd $(IMAGE_NAME); make bundle-build bundle-push IMG="$(IMG)" BUNDLE_IMG="$(BUNDLE_IMG)" VERSION="$(VERSION)" USE_IMAGE_DIGESTS="true"
deploy:
	# Run bundle
	cd $(IMAGE_NAME); operator-sdk run bundle $(BUNDLE_IMG)

	# Instantiate HPECSIDriver
	kubectl apply -f $(IMAGE_NAME)/config/samples/storage_v1_hpecsidriver.yaml
certified:
ifeq ($(BUILD_OCP),true)
	# Create certified-operators content
	rm -rf destinations/certified-operators/current-version/*
	cp -a $(IMAGE_NAME)/bundle/ destinations/certified-operators/current-version
else
	$(error Will not produce certified outputs if not BUILD_OCP=true)
endif

community:
ifeq ($(BUILD_OCP),true)
	$(error Will not produce community outputs if BUILD_OCP=true)
else
	# Create community-operators content
	rm -rf destinations/community-operators/current-version/*	
	cp -a $(IMAGE_NAME)/bundle/ destinations/community-operators/current-version
	mv destinations/community-operators/current-version/manifests/hpe-csi-operator.clusterserviceversion.yaml \
		destinations/community-operators/current-version/manifests/hpe-csi-operator.v$(VERSION).clusterserviceversion.yaml 
		cp $(IMAGE_NAME)/bundle.Dockerfile destinations/community-operators/current-version/Dockerfile
endif
