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
FROM renovate/buildpack:6@sha256:11a5e2e0ec2d52d4ccb7ca0e68489fe70089e7e3e221e392d0c69c8e04b45d38

#--------------------------------------
# Image: containerbase/buildpack
#--------------------------------------
FROM simaofsilva/containerbase-buildpack:4.5.0@sha256:d12fb59cbb41212eefb99031922597a973760cc4fd7fae833c14b0e2b280ba1f AS buildpack

#--------------------------------------
# Image: base
#--------------------------------------
FROM ubuntu:focal@sha256:35ab2bf57814e9ff49e365efd5a5935b6915eede5c7f8581e9e1b85e0eecbe16 as base

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
RUN install-tool git v2.38.0
