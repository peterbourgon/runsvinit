# runsvinit [![Circle CI](https://circleci.com/gh/peterbourgon/runsvinit.svg?style=svg)](https://circleci.com/gh/peterbourgon/runsvinit)

If you have a Docker container that's a collection of runit-supervised daemons, this process is suitable for use as the ENTRYPOINT.
See [the example](https://github.com/peterbourgon/runsvinit/tree/master/example).

**Why not use runit(8) directly?**

[runit(8)](http://smarden.org/runit/runit.8.html) is designed to be used as process 1.
And, if you provide an `/etc/service/ctrlaltdel` script, it will be executed when runit receives the INT signal.
So, we could use that hook to gracefully terminate our services.
But Docker only sends TERM on `docker stop`.

Note that the container stop signal [will become configurable](https://github.com/docker/docker/pull/15307) in Docker 1.9.
Once Docker 1.9 ships, this utility will be obsolete.

**Why not just exec runsvdir(8) directly?**

If [runsvdir(8)](http://smarden.org/runit/runsvdir.8.html) receives a signal, it doesn't wait for its supervised processes to exit before returning.

**Why not wrap runsvdir(8) in a simple shell script?**

Process 1 has the additional responsibility of [reaping orphaned child processes](https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/).
To the best of my knowledge, there is no sane way to do this with a shell script.
Otherwise, indeed, this would work great:

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

**Why not use my_init from [phusion/baseimage-docker](https://github.com/phusion/baseimage-docker)?**

my_init depends on Python 3, which might be a big dependency for such a small responsibility.

**So this is just a stripped-down my_init in Go?**

Basically, yes.
