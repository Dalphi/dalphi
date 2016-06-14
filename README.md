# DALPHI

[![Build Status](https://travis-ci.org/Dalphi/dalphi.svg?branch=master)](https://travis-ci.org/dalphi/dalphi)
[![Dependency Status](https://gemnasium.com/Dalphi/dalphi.svg)](https://gemnasium.com/Dalphi/dalphi)
[![codebeat badge](https://codebeat.co/badges/c3c6b8d5-8ef4-4a81-9d37-6ee06383fc85)](https://codebeat.co/projects/github-com-dalphi-dalphi)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/7a177baa4ea244d59202547cd6f8a975)](https://www.codacy.com/app/github_67/dalphi)
[![Code Climate](https://codeclimate.com/github/Dalphi/dalphi/badges/gpa.svg)](https://codeclimate.com/github/dalphi/dalphi)
[![Issue Count](https://codeclimate.com/github/Dalphi/dalphi/badges/issue_count.svg)](https://codeclimate.com/github/Dalphi/dalphi)

![DALPHI](https://github.com/DALPHI/DALPHI/blob/master/app/assets/images/DALPHI-logo.png)
DALPHI - Active Learning Platform for Human Interaction

## Getting started

### Kickstart with Docker

Start just the Ruby on Rails Webapp with

```
docker build -t DALPHI .
docker run -it -p 3000:3000 DALPHI
```

or launch the complete bundle including some example services and a worker with

```
docker-compose up
```

### Starting for development

DALPHI requires Ruby 2.3.1 to work properly.
With `rvm` it can be installed by running the following.

```bash
rvm install ruby-2.3.1
rvm use ruby-2.3.1
```

Get DALPHI by cloning the official repository.

```bash
git clone https://github.com/DALPHI/DALPHI.git
```

In the cloned repo run the `bundler` in order to install all dependencies.

```bash
cd DALPHI
gem install bundle
bundle install
```

Start the application with `foreman`, so that every component is started correctly.

```bash
foreman start
```

## API Documentation

DALPHI uses [Swagger](http://swagger.io/) 2.0 (compatible to [OpenAPI](https://openapis.org/)) for an interactive documentation of its API.
For the most straight forward experience, we ship the latest version of [*Swagger UI*](https://github.com/swagger-api/swagger-ui) to give you everything you need to understand our API and start developing your own Services for DALPHI.
After starting the application, *Swagger UI* will be available at [http://localhost:3000/api/swagger/](http://localhost:3000/api/swagger/).
The API specification JSON will be served at [http://localhost:3000/api/docs](http://localhost:3000/api/docs).

## Testing & Continuous Integration

DALPHI is developed applying the [Test Driven Development](https://en.wikipedia.org/wiki/Test-driven_development) paradigm. Therefore we're using [RSpec](https://en.wikipedia.org/wiki/RSpec) to specify the expected behavior of the software. Migrate the database and run RSpec by using the following script:

```bash
./bin/test
```

The [Continuous Integration](https://en.wikipedia.org/wiki/Continuous_integration) server ([Travis CI](https://travis-ci.org/)) is utilizing the following script to additionally run a set of code analyzers ([Brakeman](http://brakemanscanner.org/), [Rails Best Practices](http://rails-bestpractices.com/), [Reek](https://github.com/troessner/reek)) and linters ([Slim-Lint](https://github.com/sds/slim-lint), [SCSS-Lint](https://github.com/brigade/scss-lint), [CoffeeLint](http://www.coffeelint.org/), [RuboCop](https://github.com/bbatsov/rubocop)).

```bash
./bin/ci
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

See [LICENSE](https://raw.githubusercontent.com/DALPHI/DALPHI/master/LICENSE).
