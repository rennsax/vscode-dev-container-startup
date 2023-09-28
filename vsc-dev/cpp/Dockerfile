FROM vsc-dev/base:latest

ARG DEV_CPP_CACHE_REMOVE
ARG DEV_CPP_INSTALL_PREFIX
ARG DEV_CPP_BUILD_LLVM=0
ARG DEBIAN_FRONTEND=noninteractive
COPY dev-cpp.sh /tmp
RUN /tmp/dev-cpp.sh