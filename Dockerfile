FROM ruby:2.3.1
RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install --jobs 4
ADD . /app
CMD bundle exec rails s puma -p 3000 -b 0.0.0.0
EXPOSE 3000
