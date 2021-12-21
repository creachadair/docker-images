IMGTAG := ghcr.io/creachadair/gotest
GOVERSION := 1.17

build:
	docker buildx build -t $(IMGTAG) --build-arg=GOVERSION=$(GOVERSION) .

push-images: build
	docker image tag $(IMGTAG):latest $(IMGTAG):go$(GOVERSION)
	docker image push $(IMGTAG):latest
	docker image push $(IMGTAG):go$(GOVERSION)
