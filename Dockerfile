FROM buildpack-deps:stable@sha256:047ed8902eafcd4f535df0c7d3867cc29c52b5ec9deb1cb3bd7761be3326b9a1
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
