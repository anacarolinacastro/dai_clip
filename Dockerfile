FROM ruby:2.5

COPY . /app

WORKDIR /app

RUN bundle
