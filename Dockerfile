FROM ruby:2.3.1
RUN apt-get update
RUN apt-get install -y netcat
RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install --jobs 4
ADD . /app
RUN bundle exec rails db:migrate
CMD bundle exec foreman start
EXPOSE 3000 3001 3002 3003
