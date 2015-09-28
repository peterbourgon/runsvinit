FROM golang:1.5.1

COPY ../../*.go /go/src/github.com/peterbourgon/runsvinit
RUN go install -v github.com/peterbourgon/runsvinit
RUN mv /go/bin/runsvinit /mount/

COPY zombie.c /
RUN cc -Wall -Werror -o /zombie /zombie.c
RUN mv /zombie /mount/
