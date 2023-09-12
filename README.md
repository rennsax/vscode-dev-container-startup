# VS Code Dev Container Setup

Build your reusable dev images in a breeze.

## Install

Make sure that you have Docker (or Docker Desktop for Mac OS) installed.

### Setup the Basic Image

```sh
# The basic distro image that we use.
docker pull --platform linux/amd64 debian:latest
# Build the basic image.
cd vsc-dev/base
# Don't change the image name,
# because the following buildings depend on it.
docker build -t vsc-dev/base .
```

### Choose your language

Once you successfully build the basic image, you can choose the programming language and build the corresponding image.
```sh
cd vsc-dev/cpp
docker build -t vsc-dev/cpp .
```

## Usage

Check with the command `docker images` to make sure that you have the image installed. For example, to launch a C/C++ dev container,

```sh
# Replace <CONTAINER_NAME> with what you like.
docker run -it --name <CONTAINER_NAME> -- vsc-dev/cpp
```

Then your terminal will attach to the pseudo-tty of the container. Check the environment by

```sh
gcc --version
make --version
# ...
```

## Future

+ Create non-root users.
+ Integrate with VS Code Dev Container. (doc)

## License

MIT.

<!-- cd ../../user-config
docker build --build-arg 'base_image=vsc-dev/cpp:latest' --build-arg 'DEFAULT_USER=...'\
    --build-arg 'DEFAULT_PASSWD=...' -t vsc-dev/cpp-user . -->