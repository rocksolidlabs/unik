FROM ubuntu:14.04

RUN apt-get update && apt-get install -y curl

RUN curl --insecure https://storage.googleapis.com/golang/go1.6.2.linux-amd64.tar.gz | sudo tar xz -C /usr/local

ENV GOROOT=/usr/local/go
ENV GOPATH=$HOME/go
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin

RUN mkdir -p $GOPATH/src/github.com/emc-advanced-dev/

COPY ./ $GOPATH/src/github.com/emc-advanced-dev/unik

WORKDIR $GOPATH/src/github.com/emc-advanced-dev/unik

VOLUME /opt/build

RUN apt-get install -y git
RUN go get -u github.com/jteeuwen/go-bindata/...

CMD go-bindata -o instance-listener/bindata/instance_listener_data.go --ignore=instance-listener/bindata/ instance-listener/... && \
    perl -pi -e 's/package main/package bindata/g' instance-listener/bindata/instance_listener_data.go && \
    GOOS=${TARGET_OS} go build -o /opt/build/unik
