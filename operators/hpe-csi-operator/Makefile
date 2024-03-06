# Set these
VERSION ?= 0.0.0
REPO_NAME ?= quay.io/myrepo

# Don't set these, preferably
NAMESPACE ?= hpe-storage
VANITY_NAME ?= hpe-csi-operator
IMAGE_NAME ?= csi-driver-operator
BUNDLE_NAME ?= csi-driver-operator-bundle
IMG ?= $(REPO_NAME)/$(IMAGE_NAME):v$(VERSION)
BUNDLE_IMG ?= $(REPO_NAME)/$(BUNDLE_NAME):v$(VERSION)
BUNDLE_CHANNELS ?= stable
PLATFORMS ?= linux/arm64,linux/amd64

clean:
	operator-sdk cleanup $(VANITY_NAME) -n $(NAMESPACE)
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
	cp -f sources/hpecsidrivers.storage.hpe.com.crd.yaml \
		$(IMAGE_NAME)/config/crd/bases/storage.hpe.com_hpecsidrivers.yaml
	sed -e "s/%SEMVER%/$(VERSION)/g" -e "s#%IMG%#$(IMG)#g" \
		sources/hpe-csi-operator.csv.yaml \
		> $(IMAGE_NAME)/config/manifests/bases/hpe-csi-operator.clusterserviceversion.yaml
	cp -f sources/role.yaml $(IMAGE_NAME)/config/rbac/

	# Fix memory on the manager.
	sed -i.remove -e "s/memory: 128Mi/memory: 512Mi/g" $(IMAGE_NAME)/config/manager/manager.yaml && \
		rm -f $(IMAGE_NAME)/config/manager/manager.yaml.remove
	
	# Community and OpenShift Operators
	cd $(IMAGE_NAME); docker-buildx build --progress=plain \
	--provenance=false --push --platform=$(PLATFORMS) --tag ${IMG} -f Dockerfile .

	# Create bundle manifests
	cd $(IMAGE_NAME); make bundle CHANNELS=$(BUNDLE_CHANNELS) IMG="$(IMG)" BUNDLE_IMG="$(BUNDLE_IMG)" VERSION="$(VERSION)" USE_IMAGE_DIGESTS="true"

	# Dockerfiles
	sed -e "s|%FROM%|$(shell grep ^FROM $(IMAGE_NAME)/Dockerfile)|" sources/operator.Dockerfile > $(IMAGE_NAME)/Dockerfile
	sed -i.remove -e "s/%SEMVER%/$(VERSION)/g" $(IMAGE_NAME)/Dockerfile && \
		rm -f $(IMAGE_NAME)/Dockerfile.remove
	sed -i.remove -e "s/^FROM.*//g" $(IMAGE_NAME)/bundle.Dockerfile && \
		rm -f $(IMAGE_NAME)/bundle.Dockerfile.remove
	cat sources/bundle.Dockerfile $(IMAGE_NAME)/bundle.Dockerfile \
		> $(IMAGE_NAME)/bundle.Dockerfile-tmp && \
		mv $(IMAGE_NAME)/bundle.Dockerfile-tmp $(IMAGE_NAME)/bundle.Dockerfile

	# Annotations
	cat sources/annotations.*.yaml | tee -a $(IMAGE_NAME)/bundle/metadata/annotations.yaml

	# Create bundle image for testing
	cd $(IMAGE_NAME); make bundle-build bundle-push IMG="$(IMG)" BUNDLE_IMG="$(BUNDLE_IMG)" VERSION="$(VERSION)" USE_IMAGE_DIGESTS="true"

	# Sample CSI driver instance
	cp -f $(IMAGE_NAME)/config/samples/storage_v1_hpecsidriver.yaml \
		destinations/hpecsidriver-v${VERSION}-sample.yaml
	cp -f $(IMAGE_NAME)/config/samples/storage_v1_hpecsidriver.yaml \
		destinations/hpecsidriver-latest-sample.yaml
deploy:
	# Run bundle
	- kubectl create ns $(NAMESPACE)
	cd $(IMAGE_NAME); operator-sdk run bundle $(BUNDLE_IMG) -n $(NAMESPACE)

	# Instantiate HPECSIDriver
	kubectl apply -n $(NAMESPACE) -f destinations/hpecsidriver-v${VERSION}-sample.yaml
certified:
	# Create certified-operators content
	rm -rf destinations/certified-operators/current-version/*
	cp -f -a $(IMAGE_NAME)/bundle/ destinations/certified-operators/current-version

community:
	# Create community-operators content
	rm -rf destinations/community-operators/current-version/*	
	cp -f -a $(IMAGE_NAME)/bundle/ destinations/community-operators/current-version
	mv destinations/community-operators/current-version/manifests/hpe-csi-operator.clusterserviceversion.yaml \
		destinations/community-operators/current-version/manifests/hpe-csi-operator.v$(VERSION).clusterserviceversion.yaml 
		cp -f $(IMAGE_NAME)/bundle.Dockerfile destinations/community-operators/current-version/Dockerfile

scorecard:
	cd $(IMAGE_NAME); operator-sdk scorecard bundle -n $(NAMESPACE)
