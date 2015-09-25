# reap

If you have a Docker container that's a collection of runit-supervised daemons,
this process is suitable for use as the ENTRYPOINT.

```Docker
FROM alpine:latest
RUN echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >>/etc/apk/repositories && apk add --update runit && rm -rf /var/cache/apk/*

ADD foo /
RUN mkdir -p /etc/service/foo
ADD run-foo /etc/service/foo/run

ADD bar /
RUN mkdir -p /etc/service/bar
ADD run-bar /etc/service/bar/run

ADD reap /
ENTRYPOINT ["/reap"]
```

**Why not just exec runsvdir?**

`docker stop` issues SIGTERM (or, in a future version of Docker, perhaps another custom signal)
but if runsvdir receives a signal,
it doesn't wait for its supervised processes to exit before returning.
If you don't care about graceful shutdown of your daemons, no problem, you don't need this tool.

**Why not wrap runsvdir in a simple shell script?**

This works great:

```sh
#!/bin/sh

sv_stop() {
	for s in $(ls -d /etc/service/*)
	do
		/sbin/sv stop $s
	done
}

trap "sv_stop; exit" SIGTERM
/sbin/runsvdir /etc/service &
wait
```

...except it doesn't [reap orphaned child processes](https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/)
and is therefore unsuitable for being PID 1.

**Why not use my_init from phusion/baseimage-docker?**

That works great — if you're willing to add python3 to your Docker images :)

**So this is just a stripped-down my_init in Go?**

Basically, yes.

