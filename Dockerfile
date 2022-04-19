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
FROM renovate/buildpack:6@sha256:5acca3e8ea4db8a58b9d44cfa260f6d28478ed52f9ad664a705b6aa0a0b42967

#--------------------------------------
# Image: containerbase/buildpack
#--------------------------------------
FROM simaofsilva/containerbase-buildpack:3.14.7@sha256:3eab4bc59772a1f498d2fb96d11c3b68d87a0e5da5b2352b5c0a0c8b40fdf4fb AS buildpack

#--------------------------------------
# Image: base
#--------------------------------------
FROM ubuntu:focal@sha256:9101220a875cee98b016668342c489ff0674f247f6ca20dfc91b91c0f28581ae as base

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
