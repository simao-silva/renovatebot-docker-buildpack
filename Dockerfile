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
FROM renovate/buildpack:6@sha256:5341b837a42cd0feac1897b3477d79ec910c6f806dd8d3bfbd69efda723b164b

#--------------------------------------
# Image: containerbase/buildpack
#--------------------------------------
FROM simaofsilva/containerbase-buildpack:3.17.4@sha256:4564330f5386a492d938b60f2a4a14f0e4672187c5421c66decda5458eaa18e0 AS buildpack

#--------------------------------------
# Image: base
#--------------------------------------
FROM ubuntu:focal@sha256:adbc8b8e1a56d35c0789b1e6cbac809efa213802f67a26d0b78fc14eade7d1dd as base

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
RUN install-tool git v2.36.1
