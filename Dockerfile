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
FROM renovate/buildpack:6@sha256:8ffd446a87786b9ea68c5c4058ee47eec3fd8f22cb74232f7541f722d04d1bd2

#--------------------------------------
# Image: containerbase/buildpack
#--------------------------------------
FROM simaofsilva/containerbase-buildpack:3.15.0@sha256:0aa762e0b2f24795527f502ef8133f6d4293a5d18ba8742c87180e98da3c5115 AS buildpack

#--------------------------------------
# Image: base
#--------------------------------------
FROM ubuntu:jammy@sha256:2a7dffab37165e8b4f206f61cfd984f8bb279843b070217f6ad310c9c31c9c7c as base

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
RUN install-tool git v2.36.0
