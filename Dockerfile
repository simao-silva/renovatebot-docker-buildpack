#--------------------------------------
# Target image to build
#--------------------------------------
ARG TARGET=latest

#--------------------------------------
# Non-root user to create
#--------------------------------------
ARG USER_ID=1000
ARG USER_NAME=ubuntu

#--------------------------------------
# Note: Only used to force a new build to keep up with
#       the newest changes in the upstream repository
#--------------------------------------
FROM renovate/buildpack:6@sha256:21dc773894c12276bb3ed23dac42728eddcab5dcb406db7eb03295f226ce7de9

#--------------------------------------
# Image: containerbase/buildpack
#--------------------------------------
FROM simaofsilva/containerbase-buildpack:3.7.2@sha256:73eb90682136639719f90b9633268ac2e3a96ff84c0f7d9e846a950db20e8a00 AS buildpack

#--------------------------------------
# Image: base
#--------------------------------------
FROM ubuntu:focal@sha256:8ae9bafbb64f63a50caab98fd3a5e37b3eb837a3e0780b78e5218e63193961f9 as base

ARG USER_ID
ARG USER_NAME


# Weekly cache buster
ARG CACHE_WEEK


#  autoloading buildpack env
ENV BASH_ENV=/usr/local/etc/env PATH=/home/$USER_NAME/bin:$PATH
SHELL ["/bin/bash" , "-c"]

# This entry point ensures that dumb-init is run
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD [ "bash" ]

# Set up buildpack
COPY --from=buildpack /usr/local/bin/ /usr/local/bin/
COPY --from=buildpack /usr/local/buildpack/ /usr/local/buildpack/
RUN install-buildpack


# renovate: datasource=github-tags depName=git/git
RUN install-tool git v2.35.1
