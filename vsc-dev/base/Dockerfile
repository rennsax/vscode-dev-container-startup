# syntax=docker/dockerfile:1
FROM debian:latest

ARG DEBIAN_FRONTEND=noninteractive
# Update packages and install dispensable utilities
COPY scripts/setup.sh /tmp
RUN /tmp/setup.sh

COPY scripts/prerequisite.sh /tmp
RUN /tmp/prerequisite.sh -v

CMD [ "/bin/zsh" ]