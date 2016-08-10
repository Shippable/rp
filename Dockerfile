FROM shipimg/microbase:{{%TAG%}}
MAINTAINER ragesh@rageshkrishna.com

RUN echo "deb http://archive.ubuntu.com/ubuntu precise restricted multiverse" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y python-software-properties software-properties-common
RUN apt-add-repository -y ppa:nginx/stable && apt-get update
RUN apt-get update
RUN apt-get install -y nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
ADD default /etc/nginx/sites-enabled/default

EXPOSE 80
CMD service nginx start
