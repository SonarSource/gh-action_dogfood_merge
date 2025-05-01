FROM buildpack-deps:stable@sha256:8c30a94b4fb5caf5bd7d24f45791b590a56c1260191876b06404692a507f366a
LABEL maintainer="David Rautureau <david.rautureau@sonarsource.com>"

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
