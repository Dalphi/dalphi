FROM ruby:2.4.0

RUN \
	apt-get update && \
	apt-get install -y netcat && \
	mkdir /app

ADD Gemfile* /tmp/
RUN \
	cd /tmp && \
	bundle install

WORKDIR /usr/src/app
ADD . /usr/src/app
RUN bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bin/start"]
