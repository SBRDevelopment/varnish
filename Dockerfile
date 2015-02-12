FROM ubuntu:14.04
MAINTAINER Brian Wight "bwight@sbrforum.com"

RUN apt-get update && \
	apt-get install -y varnish && \
	apt-get clean

ONBUILD COPY default.vcl /etc/varnish/default.vcl
ONBUILD COPY default /etc/default/varnish

COPY entrypoint /usr/bin/entrypoint

RUN entrypoint check

CMD entrypoint start