FROM buildpack-deps:stable@sha256:ed1cd9d906c3dc8b4b29c391abd40b8f397951418a74802df688b22fea2cd61f
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
