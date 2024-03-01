# CSUMB Security Lab

## How to use this repo

0. Install Docker (see section)
1. git clone https://github.com/camsterrrr/CsumbSecurityLab/
2. cd CsumbSecurityLab
3. ./scripts/build
4. ./scripts/run
5. ./scripts/build

## Install Docker

Docker isn't natively installed on Ubuntu. There was some setup I needed to do and packages I needed to install.

### Docker-related packages

I followed this guide to setup docker for my Ubuntu server, https://docs.docker.com/engine/install/ubuntu/. I'm not sure what the first few steps are doing, so I'll just include the apt packages I installed below.

```BASH
$ sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

## Building the Docker image

Below we are using a `docker build` command to build the Dockerfile into an image. Once we have a cached image, we can run `docker run` to create a new container. I used this in a BASH script because it is too annoying to type out.

Note that here we are searching the working directory (".") for a file name "Dockerfile". 

```BASH
sudo docker build -t hackathon-image .
```

A word on Docker images: An image is an executable package that provides everything needed to run a piece of software. It can include, code, libraries, env vars, and configuration files. Images are built from instructions specified in a Dockerfile, and aren't meant to be changed. Images determine how containers are created/compiled.

## Running the Docker container

Now that we have cached image, let us use `docker run` to create a docker container that will actually run the server. Note that we are outputting stdin and stderr into log files.

```BASH
sudo docker run -d -p 5000:5000/udp -p 5002:5002/udp -p 5000:5000/tcp -p 5002:5002/tcp --name hackathon-container hackathon-image tail -f /dev/null
```

Note that the `tail -f /dev/null` is used so that the container doesn't exit once it created. This will allow the container to run continuously.

A word on Docker containers: A container is a runable instance of an image. It provides an execution environment for any packages, libraries, or configurations specified in an image. A container can be started, stopped, restarted, etc. Each container is isolated from others running on a host.

## Setting port forward

The `docker run` command we used already maps ports on the host machine to the docker container, so it will forward any traffic received on ports 5000 and 5002 to the Docker container. All that is really needed is setting a port forward on the hosts default gateway.

## Extra Docker info I learned

### Docker commands

0. Simple hello-world: `sudo docker run hello-world`
1. Ubuntu container: `sudo docker pull ubuntu:22.04`
2. List all cached images: `sudo docker images`
3. Remove a image: `sudo docker rmi {image name or id}`
4. List all containers: `sudo docker ps -a`
5. Remve a container: `sudo docker rm {container name or id}`
6. Create a container from an image: `sudo docker run -it --name hackathon-container ubuntu:22.04`
7. Create new image from container: `sudo docker commit hackathon-container hackathon-image`
8. Open container from new image: `sudo docker run -it --name hackathon-container hackathon-image`
9. Start container: `sudo docker start hackathon-container`
	- Note that this will just start it in the backgorund, there will be no interactive terminal yet.
10. Interact with running container: `sudo docker exec -it hackathon-container /bin/bash`

Note that the `run` option will look in the local cache for any images that match the specified image. If nothing matches, it will go out to DockerHub and fetch the specified image, the image will now be in the cache.

```BASH
sudo docker run hello-world
	Unable to find image 'hello-world:latest' locally
	latest: Pulling from library/hello-world
	c1ec31eb5944: Pull complete
	Digest: sha256:ac69084025c660510933cca701f615283cdbb3aa0963188770b54c31c8962493
	Status: Downloaded newer image for hello-world:latest

	Hello from Docker!
	...
sudo docker run hello-world

	Hello from Docker!
	...
```

### Useful options

sudo docker run {...}
- -i, keeps STDIN open even if not attached.
- --name minecraftUbuntu, specifies the name of the container as minecraftUbuntu.
- -p 127.0.0.1:80:8080/tcp, exposes port to host OS.
	- Ensure UFW doesn't block connections to port.
- -t or --tty, allocates a pseudo-TTY, which allows you to interact with the container through a terminal.
- -u {username}, specifies a username to login with.
- -v {$(pwd):$(pwd)}, mount volume within file system // -v ./content:/content
	- --read-only, control whether container can write files.
- -w /path/to/dir, set working directory.
- /bin/bash, the command to run inside the container. In this case, it starts an interactive Bash shell.
