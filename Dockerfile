#ruby 2.7.1 image from docker-hub
FROM ruby:2.7.1

MAINTAINER Nikhil Gupta

#Installing NodeJs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg 
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list 
RUN apt-get update && apt-get install -y --no-install-recommends nodejs yarn

COPY . .

WORKDIR app/
RUN gem install rails 
RUN gem install sqlite3 
RUN bundle update listen


RUN bundle install --no-deployment

WORKDIR /opt
RUN rails new blog ---skip-active-record --skip-active-storage -T --skip-bundle

WORKDIR blog/

RUN bundle add cequel 
RUN bundle add activemodel-serializers-xml 
RUN rails g scaffold post title body

COPY cequel.yml /opt/blog/config/

#Expose 3000 default  port
EXPOSE 3000

