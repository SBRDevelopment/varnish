FROM ubuntu:14.04
MAINTAINER Brian Wight "bwight@sbrforum.com"

RUN apt-get update && \
	apt-get install -y curl wget apt-transport-https libreadline-dev libncurses5-dev libpcre3-dev libssl-dev libluajit-5.1-dev perl make build-essential

RUN curl https://repo.varnish-cache.org/ubuntu/GPG-key.txt | sudo apt-key add -
RUN sudo sh -c 'echo "deb https://repo.varnish-cache.org/ubuntu/ trusty varnish-4.0" >> /etc/apt/sources.list.d/varnish-cache.list'

RUN apt-get update && \
	apt-get install -y varnish && \
	apt-get clean

RUN wget http://openresty.org/download/ngx_openresty-1.7.7.2.tar.gz && \
	tar xzvf ngx_openresty-1.7.7.2.tar.gz && \
	cd ngx_openresty-1.7.7.2/ && \
	./configure --prefix=/etc/ \
	--with-pcre-jit \
	--with-ipv6 \
	--with-http_iconv_module \
	-j2

RUN cd ngx_openresty-1.7.7.2/ && \
	make && \
	make install && \
	rm -rf ../ngx_openresty*

RUN mkdir -p /var/log/nginx

COPY nginx.conf /etc/nginx/conf/nginx.conf
COPY entrypoint /usr/bin/entrypoint

ONBUILD COPY default.vcl /etc/varnish/default.vcl
ONBUILD COPY default /etc/default/varnish

CMD entrypoint start