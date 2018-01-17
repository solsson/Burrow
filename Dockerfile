FROM golang:1.9.2-alpine3.6@sha256:577cd4aa00e214b007d12d8b4c9edd2ef096794366ec9afbc7eb2daf9da61744

MAINTAINER LinkedIn Burrow "https://github.com/linkedin/Burrow"

RUN apk add --no-cache curl bash git ca-certificates wget \
 && update-ca-certificates \
 && curl -sSO https://raw.githubusercontent.com/pote/gpm/v1.4.0/bin/gpm \
 && chmod +x gpm \
 && mv gpm /usr/local/bin

ADD . $GOPATH/src/github.com/linkedin/Burrow
RUN cd $GOPATH/src/github.com/linkedin/Burrow \
 && gpm install \
 && go install \
 && mv $GOPATH/bin/Burrow $GOPATH/bin/burrow \
 && apk del git curl wget

ADD docker-config /etc/burrow

WORKDIR /var/tmp/burrow

CMD ["/go/bin/burrow", "--config-dir", "/etc/burrow"]
