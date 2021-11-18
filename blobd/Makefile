# These settings control the image built by "make build".
DATAVOL ?= blobdata
NETWORK ?= 127.0.0.1
CNAME   ?= blobd
STORES  ?= badger,gcs,s3

# These settings control the container started by "make start".
STORE   ?= badger:blobdata.db
PORT    ?= 19741

IMGNAME := ghcr.io/creachadair/blobd

.PHONY: build start stop

# Build an image containing the blobd binary.
build:
	docker buildx build -t $(IMGNAME) --build-arg TAGS=$(STORES) .

# Start a container running blobd with the given settings.
# The service is exported to the host under the same port.
start:
	docker run --detach --volume $(DATAVOL):/data \
		--name $(CNAME) \
		--publish $(NETWORK):$(PORT):$(PORT) \
		$(IMGNAME) \
		-store $(STORE) -listen :$(PORT)

stop:
	docker stop $(CNAME) && docker rm $(CNAME)
