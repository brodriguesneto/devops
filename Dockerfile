FROM alpine:latest
MAINTAINER Boaventura Rodrigues Neto <brodriguesneto@gmail.com>
LABEL "app"="devops"
ENV AP /opt/app
WORKDIR $AP
ADD Gemfile $AP/
ADD devops.rb $AP/
ADD public $AP/public
RUN apk update && apk upgrade && apk add ruby ruby-json ruby-bundler && bundle install && rm -rf /var/cache/apk/*
CMD ["ruby", "devops.rb"]