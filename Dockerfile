FROM ruby:2.2.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir /dk-survey
WORKDIR /dk-survey
ADD . /dk-survey

RUN bundle install --path vendor/bundle
