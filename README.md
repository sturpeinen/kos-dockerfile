# KallistiOS Dockerfile

## Building

### Building latest dc-chain, KallistiOS and ports
Since docker doesn't know if the repositories have changed, ```--no-cache``` should be used. This way docker ignores previous commits.
```
$ cd /path/to/kos-dockerfile
$ docker build --no-cache -t kos:latest .
```

### Building specific dc-chain and KallistiOS versions
Specific dc-chain and KallistiOS versions can be build by using ```DC_CHAIN_REV``` and ```KOS_REV``` build arguments. This way the slow process of building dc-chain can be skipped if there is no changes to it. If ```DC_CHAIN_REV``` is changed between builds, KallistiOS is also rebuild. If ```DC_CHAIN_REV``` stays the same but ```KOS_REV``` changes, only KallistiOS is rebuild. **Note: Ports are build with KallistiOS and latest revision is always used.**
```
$ cd /path/to/kos-dockerfile
$ docker build --build-arg DC_CHAIN_REV=818465f --build-arg KOS_REV=e92de29 -t kos:latest .
```

## Cross-compiling & dc-tool

### Compiling elf
```
$ cd /your/kos/project
$ docker run -it --rm -v $(pwd):/data kos:latest make
```

### Uploading elf using dc-tool and Dreamcast Broadband Adapter (HIT-0400)
Setup IP address for the Broadband Adapter and test the connection. Linux example:
```
$ sudo ip n add 10.0.0.42 lladdr 00:d0:f1:02:7c:1b dev enp0s31f6 nud perm
$ ping 10.0.0.42
```
Upload your elf using dc-tool.
```
$ cd /your/kos/project
$ docker run -it --rm --net=host -v $(pwd):/data kos:latest "dc-tool -t 192.168.1.10 -x someproject.elf"
```
