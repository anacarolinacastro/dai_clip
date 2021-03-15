FROM ruby:2.5

COPY . /app

WORKDIR /app

RUN bundle

ENTRYPOINT ruby dai_clip.rb $EXTRA_OPTS
