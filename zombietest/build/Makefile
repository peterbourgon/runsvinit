.PHONY: all
all: zombie runsvinit

zombie runsvinit: .uptodate
	docker run -ti --rm -v $(shell pwd):/mount zombie-build

.uptodate: Dockerfile ../../*.go
	docker build -t zombie-build .
	touch $@
