ARG FROM_BASE=${DOCKER_REGISTRY:-s2.ubuntu.home:5000/}${CONTAINER_OS:-alpine}/base_container:${BASE_TAG:-latest} 
FROM $FROM_BASE

# name and version of this docker image
ARG CONTAINER_NAME=python
# Specify CBF version to use with our configuration and customizations
ARG CBF_VERSION

# include our project files
COPY build Dockerfile /tmp/

# set to non zero for the framework to show verbose action scripts
#    (0:default, 1:trace & do not cleanup; 2:continue after errors)
ENV DEBUG_TRACE=0


# java version being bundled in this docker image
ARG PYTHON_VERSION=3.9.13-r1
LABEL version.java=$PYTHON_VERSION
ARG PIP_VERSION=19.1
LABEL version.pip=$PIP_VERSION


# build content
RUN set -o verbose \
    && chmod u+rwx /tmp/build.sh \
    && /tmp/build.sh "$CONTAINER_NAME" "$DEBUG_TRACE" "$TZ" \
    && ([ "$DEBUG_TRACE" != 0 ] || rm -rf /tmp/*)


ENTRYPOINT [ "docker-entrypoint.sh" ]
#CMD ["$CONTAINER_NAME"]
CMD ["python"]
