.PHONY: docker
docker: runsvinit
	docker build -t runsvinit-example .

runsvinit: $GOPATH/bin/runsvinit
	cp $< $@

$GOPATH/bin/runsvinit:
	go get -u github.com/peterbourgon/runsvinit

