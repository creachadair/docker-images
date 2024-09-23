# These settings control the image built by "make build".
DATAVOL ?= ffs-storage-data
NETWORK ?= 127.0.0.1
CNAME   ?= ffs-storage
STORES  ?= file,memory
PROXY   ?= $(GOPROXY)
DESC    ?= "FFS storage server"

# These settings control the container started by "make start".
STORE   ?= badger:data.db
PORT    ?= 19741

IMGNAME := ghcr.io/creachadair/ffs
IMGVERS := latest

.PHONY: build images minimal omnibus standard start stop

# Build an image containing the ffs binary.
build:
	docker buildx build -t $(IMGNAME):$(IMGVERS) \
	  --build-arg TAGS=$(STORES) \
	  --build-arg PROXY=$(PROXY) \
	  --build-arg DESC=$(DESC) \
	  .

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

clean-images:
	@for vs in omnibus standard minimal ; do \
	  docker image rm -f "$(IMGNAME):$$vs" 2>/dev/null ; \
	done

minimal: IMGVERS=minimal
minimal: DESC='FFS tool with baseline file and in-memory implementations'
minimal: build

standard: IMGVERS=standard
standard: STORES=badger,gcs,s3
standard: DESC='FFS tool with BadgerDB, GCS, and S3 implementations'
standard: build

omnibus: IMGVERS=omnibus
omnibus: STORES=all
omnibus: DESC='FFS tool with all supported storage implementations'
omnibus: build

# Start a container running ffs storage with the given settings.
# The service is exported to the host under the same port.
start: IMGVERS=standard
start:
	docker run --detach --volume $(DATAVOL):/data \
		--name $(CNAME) \
		--publish $(NETWORK):$(PORT):$(PORT) \
		$(IMGNAME):$(IMGVERS) \
		storage --store $(STORE) --listen :$(PORT)

stop:
	docker stop $(CNAME) && docker rm $(CNAME)
