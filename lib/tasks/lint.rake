namespace :lint do
  desc 'lint coffee script assets'
  task coffee: :environment do
    require 'coffeelint'
    exit Coffeelint.run_test_suite(
      'app/assets/javascripts',
      config_file: 'config/linters/coffeelint.json'
    )
  end
end
