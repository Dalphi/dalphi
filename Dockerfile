FROM ruby:2.5.0

WORKDIR /usr/src/app
COPY Gemfile* /usr/src/app/
RUN bundle install
COPY . /usr/src/app

CMD ["bin/start"]
