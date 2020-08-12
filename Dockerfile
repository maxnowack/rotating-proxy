FROM ubuntu:18.04

COPY start.rb /usr/local/bin/start.rb
COPY newnym.sh /usr/local/bin/newnym.sh
COPY haproxy.cfg.erb /usr/local/etc/haproxy.cfg.erb
COPY uncachable /etc/polipo/uncachable

RUN apt-get update && \
    apt-get install -y wget gnupg && \
    echo 'deb http://deb.torproject.org/torproject.org trusty main' | tee /etc/apt/sources.list.d/torproject.list && \
    wget https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc && \
    apt-key add A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc && \
    echo 'deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu trusty main' | tee /etc/apt/sources.list.d/ruby.list && \
    gpg --keyserver keyserver.ubuntu.com --recv C3173AA6 && \
    gpg --export 80f70e11f0f0d5f10cb20e62f5da5f09c3173aa6 | apt-key add - && \
    apt-get install -y tor polipo haproxy ruby libssl-dev curl build-essential zlib1g-dev libyaml-dev libssl-dev netcat && \
    ln -s /lib/x86_64-linux-gnu/libssl.so.1.0.0 /lib/libssl.so.1.0.0 && \
    update-rc.d -f tor remove && \
    update-rc.d -f polipo remove && \
    gem install excon -v 0.44.4 && \
    chmod +x /usr/local/bin/newnym.sh && \
    chmod +x /usr/local/bin/start.rb && \
    rm -rf A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc

EXPOSE 5566 4444

CMD /usr/local/bin/start.rb
