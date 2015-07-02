FROM ubuntu:14.04
MAINTAINER Brian Wight "bwight@sbrforum.com"

RUN apt-get update && \
	apt-get install -y wget \
	libreadline-dev \
	libncurses5-dev \
	libpcre3-dev \
	libssl-dev \
	libluajit-5.1-dev \
	perl \
	make \
	build-essential

RUN wget http://openresty.org/download/ngx_openresty-1.7.7.2.tar.gz && \
	tar xzvf ngx_openresty-1.7.7.2.tar.gz && \
	cd ngx_openresty-1.7.7.2/ && \
	./configure --prefix=/opt/openresty \
	--with-pcre-jit \
	--with-ipv6 \
	--with-http_iconv_module \
	-j2

RUN cd ngx_openresty-1.7.7.2/ && make && make install

RUN apt-get update && \
	apt-get install -y varnish && \
	apt-get clean

RUN mkdir -p /var/log/nginx

ONBUILD COPY default.vcl /etc/varnish/default.vcl
ONBUILD COPY default /etc/default/varnish

COPY entrypoint /usr/bin/entrypoint

ONBUILD RUN entrypoint check

CMD entrypoint start