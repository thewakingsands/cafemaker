FROM ubuntu:bionic

ADD /web /vagrant
ADD /docker/bin /cafemaker/bin

RUN bash /cafemaker/bin/install.sh
CMD ["/cafemaker/bin/start.sh"]
