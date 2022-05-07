# These settings control the image built by "make build".
DATAVOL ?= blobdata
NETWORK ?= 127.0.0.1
CNAME   ?= blobd
STORES  ?= badger,gcs,s3
PROXY   ?= $(GOPROXY)

# These settings control the container started by "make start".
STORE   ?= badger:blobdata.db
PORT    ?= 19741

IMGNAME := ghcr.io/creachadair/blobd
IMGVERS := latest

.PHONY: build images minimal omnibus standard start stop

# Build an image containing the blobd binary.
build:
	docker buildx build -t $(IMGNAME):$(IMGVERS) \
	  --build-arg TAGS=$(STORES) --build-arg PROXY=$(PROXY) .

# Build image variations. Note we have to call make explicitly for each of
# these, since only one set of target-specific settings will be applied to a
# given rule per invocation.
images:
	@make minimal
	@make standard
	@make omnibus

# Build and push images to the registry.
push-images: images
	@for vs in omnibus standard minimal ; do \
	   docker image push "$(IMGNAME):$$vs" ; \
	done

minimal: IMGVERS=minimal
minimal: STORES=file,memory
minimal: build

standard: IMGVERS=standard
standard: build

omnibus: IMGVERS=omnibus
omnibus: STORES=all
omnibus: build

# Start a container running blobd with the given settings.
# The service is exported to the host under the same port.
start:
	docker run --detach --volume $(DATAVOL):/data \
		--name $(CNAME) \
		--publish $(NETWORK):$(PORT):$(PORT) \
		$(IMGNAME):$(IMGVERS) \
		-store $(STORE) -listen :$(PORT)

stop:
	docker stop $(CNAME) && docker rm $(CNAME)
