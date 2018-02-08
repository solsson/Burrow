FROM golang:1.9.2-alpine3.6@sha256:577cd4aa00e214b007d12d8b4c9edd2ef096794366ec9afbc7eb2daf9da61744

MAINTAINER LinkedIn Burrow "https://github.com/linkedin/Burrow"

# https://github.com/golang/dep/releases
ENV \
  GODEP_URL=https://github.com/golang/dep/releases/download/v0.3.2/dep-linux-amd64 \
  GODEP_SHA256=322152b8b50b26e5e3a7f6ebaeb75d9c11a747e64bbfd0d8bb1f4d89a031c2b5

ADD . $GOPATH/src/github.com/linkedin/Burrow

RUN set -x \
  && apk --update --no-cache add --virtual build-dependencies curl ca-certificates git \
  && curl -SLs -o /usr/local/bin/dep "${GODEP_URL}" \
  && sha256sum /usr/local/bin/dep \
  && echo "${GODEP_SHA256}  /usr/local/bin/dep" | sha256sum -c \
  && chmod u+x /usr/local/bin/dep \
  && cd $GOPATH/src/github.com/linkedin/Burrow \
  && dep ensure \
  && go install \
  && mv $GOPATH/bin/Burrow $GOPATH/bin/burrow \
  && rm /usr/local/bin/dep \
  && apk del build-dependencies

ADD docker-config /etc/burrow

WORKDIR /var/tmp/burrow

CMD ["/go/bin/burrow", "--config-dir", "/etc/burrow"]
