FROM buildpack-deps:stable@sha256:aae84bd20debfe55c6f5fcb3289582354f69d73e6ee90694105c1922453ef18a
LABEL maintainer="Engineering Experience Squad <platform.eng-xp@sonarsource.com>"

ENV GIT_OCTOPUS_VERSION=1.4
ENV DEBIAN_FRONTEND=noninteractive

# Install git-octopus
RUN wget https://github.com/lesfurets/git-octopus/archive/v${GIT_OCTOPUS_VERSION}.tar.gz \
    && tar xvf *.tar.gz \
    && cd git-octopus-${GIT_OCTOPUS_VERSION} \
    && make install \
    && rm -Rf *

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
