# dalphi

[![Build Status](https://travis-ci.org/implisense/dalphi.svg?branch=master)](https://travis-ci.org/implisense/dalphi)
[![Code Climate](https://codeclimate.com/github/implisense/dalphi/badges/gpa.svg)](https://codeclimate.com/github/implisense/dalphi)
[![codebeat badge](https://codebeat.co/badges/c3c6b8d5-8ef4-4a81-9d37-6ee06383fc85)](https://codebeat.co/projects/github-com-implisense-dalphi)
[![Codacy Badge](https://api.codacy.com/project/badge/grade/312f3902da6d4e0687483b51a8bcbe4c)](https://www.codacy.com/app/robert_10/dalphi)
[![Test Coverage](https://codeclimate.com/github/implisense/dalphi/badges/coverage.svg)](https://codeclimate.com/github/implisense/dalphi/coverage)
[![Dependency Status](https://gemnasium.com/implisense/dalphi.svg)](https://gemnasium.com/implisense/dalphi)
[![Issue Count](https://codeclimate.com/github/implisense/dalphi/badges/issue_count.svg)](https://codeclimate.com/github/implisense/dalphi)

![Dalphi](https://github.com/implisense/dalphi/blob/master/app/assets/images/dalphi-logo.png)
Dalphi - Active Learning Platform for Human Interaction

## Getting started

Dalphi requires Ruby 2.3.0 to work properly.
With `rvm` it can be installed by running the following.

```bash
rvm install ruby-2.3.0
rvm use ruby-2.3.0
```

Get Dalphi by cloning the official repository.

```bash
git clone https://github.com/implisense/dalphi.git
```

In the cloned repo run the `bundler` in order to install all dependencies.

```bash
cd dalphi
gem install bundle
bundle install
```

Start the application with `foreman`, so that every component is started correctly.

```bash
foreman start
```

## Testing & Continuous Integration

Dalphi is developed applying the [Test Driven Development](https://en.wikipedia.org/wiki/Test-driven_development) paradigm. Therefore we're using [RSpec](https://en.wikipedia.org/wiki/RSpec) to specify the expected behavior of the software. Migrate the database and run RSpec by using the following script:

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

See [LICENSE](https://raw.githubusercontent.com/implisense/dalphi/master/LICENSE).
