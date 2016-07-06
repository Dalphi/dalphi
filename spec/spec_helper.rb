require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: false, allow: ['codeclimate.com'])

# This file was generated by the `rails generate rspec:install` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# The generated `.rspec` file contains `--require spec_helper` which will cause
# this file to always be loaded, without a need to explicitly require it in any
# files.
#
# Given that it is always loaded, you are encouraged to keep this file as
# light-weight as possible. Requiring heavyweight dependencies from this file
# will add to the boot time of your test suite on EVERY test run, even for an
# individual file that may not need all of that loaded. Instead, consider making
# a separate helper file that requires the additional dependencies and performs
# the additional setup, and require it from the spec files that actually need
# it.
#
# The `.rspec` file also contains a few flags that are not defaults but that
# users commonly want.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

# The settings below are suggested to provide a good initial experience
# with RSpec, but feel free to customize to your heart's content.
=begin
  # This allows you to limit a spec run to individual examples or groups
  # you care about by tagging them with `:focus` metadata. When nothing
  # is tagged with `:focus`, all examples get run. RSpec also provides
  # aliases for `it`, `describe`, and `context` that include `:focus`
  # metadata: `fit`, `fdescribe` and `fcontext`, respectively.
  config.filter_run_when_matching :focus

  # Allows RSpec to persist some state between runs in order to support
  # the `--only-failures` and `--next-failure` CLI options. We recommend
  # you configure your source control system to ignore this file.
  config.example_status_persistence_file_path = "spec/examples.txt"

  # Limits the available syntax to the non-monkey patched syntax that is
  # recommended. For more details, see:
  #   - http://rspec.info/blog/2012/06/rspecs-new-expectation-syntax/
  #   - http://www.teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
  #   - http://rspec.info/blog/2014/05/notable-changes-in-rspec-3/#zero-monkey-patching-mode
  config.disable_monkey_patching!

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  config.profile_examples = 10

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed
=end

  config.before(:each) do
    stub_request(:get, 'http://localhost:3000/').
      with(:headers => {'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'localhost:3000', 'User-Agent' => 'Ruby'}).
      to_return(status: 200, body: '', headers: {})
    stub_request(:get, 'http://localhost:3001/').
      with(:headers => {'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'localhost:3001', 'User-Agent' => 'Ruby'}).
      to_return(status: 200, body: '', headers: {})
    stub_request(:get, "http://localhost:3002/").
       with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'localhost:3002', 'User-Agent'=>'Ruby'}).
       to_return(:status => 200, :body => "", :headers => {})
    stub_request(:get, 'http://www.google.us/').
      with(:headers => {'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'www.google.us', 'User-Agent' => 'Ruby'}).
      to_return(status: 200, body: '', headers: {})
    stub_request(:get, 'http://www.google.com/').
      with(:headers => {'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'www.google.com', 'User-Agent' => 'Ruby'}).
      to_return(status: 302, body: '', headers: {})
    stub_request(:get, 'http://petstore.swagger.io/v2/swagger.json').
      with(:headers => {'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'petstore.swagger.io', 'User-Agent' => 'Ruby'}).
      to_return(status: 200, body: '', headers: {})
    stub_request(:get, 'http://petstore.swagger.io/').
      with(:headers => {'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'petstore.swagger.io', 'User-Agent' => 'Ruby'}).
      to_return(status: 200, body: '', headers: {})
    stub_request(:get, 'http://www.3antworten.de/').
      with(:headers => {'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'www.3antworten.de', 'User-Agent' => 'Ruby'}).
      to_return(:status  =>  200, body: '', headers: {})
    stub_request(:get, 'http://www.3antworten.com/').
      with(:headers => {'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'www.3antworten.com', 'User-Agent' => 'Ruby'}).
      to_return(status: 200, body: '', headers: {})
    stub_request(:get, 'http://g.co/').
      with(:headers => {'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'g.co', 'User-Agent' => 'Ruby'}).
      to_return(status: 302, body: '', headers: {})
    stub_request(:get, 'http://www.google.org/').
      with(:headers => {'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'www.google.org', 'User-Agent' => 'Ruby'}).
      to_return(status: 302, body: '', headers: {})
    stub_request(:get, 'http://www.google.de/').
      with(:headers => {'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'www.google.de', 'User-Agent' => 'Ruby'}).
      to_return(status: 302, body: '', headers: {})
    stub_request(:get, "http://example.com/unreachable/resource").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'example.com', 'User-Agent'=>'Ruby'}).
      to_return(:status => 404, :body => "", :headers => {})
    stub_request(:get, "http://yet-another-dalphi-service.com/").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'yet-another-dalphi-service.com', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => "", :headers => {})
    stub_request(:post, 'http://www.google.de/').
      with(:body => "[{\"raw_datum_id\":1,\"content\":\"TG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFtZXQsIGNvbnNlY3RldHVlciBhZGlw\\naXNjaW5nIGVsaXQuIEFlbmVhbiBjb21tb2RvIGxpZ3VsYSBlZ2V0IGRvbG9y\\nLiBBZW5lYW4gbWFzc2EuIEN1bSBzb2NpaXMgbmF0b3F1ZSBwZW5hdGlidXMg\\nZXQgbWFnbmlzIGRpcyBwYXJ0dXJpZW50IG1vbnRlcywgbmFzY2V0dXIgcmlk\\naWN1bHVzIG11cy4gRG9uZWMgcXVhbSBmZWxpcywgdWx0cmljaWVzIG5lYywg\\ncGVsbGVudGVzcXVlIGV1LCBwcmV0aXVtIHF1aXMsIHNlbS4gTnVsbGEgY29u\\nc2VxdWF0IG1hc3NhIHF1aXMgZW5pbS4gRG9uZWMgcGVkZSBqdXN0bywgZnJp\\nbmdpbGxhIHZlbCwgYWxpcXVldCBuZWMsIHZ1bHB1dGF0ZSBlZ2V0LCBhcmN1\\nLiBJbiBlbmltIGp1c3RvLCByaG9uY3VzIHV0LCBpbXBlcmRpZXQgYSwgdmVu\\nZW5hdGlzIHZpdGFlLCBqdXN0by4gTnVsbGFtIGRpY3R1bSBmZWxpcyBldSBw\\nZWRlIG1vbGxpcyBwcmV0aXVtLiBJbnRlZ2VyIHRpbmNpZHVudC4gQ3JhcyBk\\nYXBpYnVzLiBWaXZhbXVzIGVsZW1lbnR1bSBzZW1wZXIgbmlzaS4gQWVuZWFu\\nIHZ1bHB1dGF0ZSBlbGVpZmVuZCB0ZWxsdXMuIEFlbmVhbiBsZW8gbGlndWxh\\nLCBwb3J0dGl0b3IgZXUsIGNvbnNlcXVhdCB2aXRhZSwgZWxlaWZlbmQgYWMs\\nIGVuaW0uIEFsaXF1YW0gbG9yZW0gYW50ZSwgZGFwaWJ1cyBpbiwgdml2ZXJy\\nYSBxdWlzLCBmZXVnaWF0IGEsIHRlbGx1cy4gUGhhc2VsbHVzIHZpdmVycmEg\\nbnVsbGEgdXQgbWV0dXMgdmFyaXVzIGxhb3JlZXQuIFF1aXNxdWUgcnV0cnVt\\nLiBBZW5lYW4gaW1wZXJkaWV0LiBFdGlhbSB1bHRyaWNpZXMgbmlzaSB2ZWwg\\nYXVndWUuIEN1cmFiaXR1ciB1bGxhbWNvcnBlciB1bHRyaWNpZXMgbmlzaS4g\\nTmFtIGVnZXQgZHVpLiBFdGlhbSByaG9uY3VzLiBNYWVjZW5hcyB0ZW1wdXMs\\nIHRlbGx1cyBlZ2V0IGNvbmRpbWVudHVtIHJob25jdXMsIHNlbSBxdWFtIHNl\\nbXBlciBsaWJlcm8sIHNpdCBhbWV0IGFkaXBpc2Npbmcgc2VtIG5lcXVlIHNl\\nZCBpcHN1bS4gTmFtIHF1YW0gbnVuYywgYmxhbmRpdCB2ZWwsIGx1Y3R1cyBw\\ndWx2aW5hciwgaGVuZHJlcml0IGlkLCBsb3JlbS4gTWFlY2VuYXMgbmVjIG9k\\naW8gZXQgYW50ZSB0aW5jaWR1bnQgdGVtcHVzLiBEb25lYyB2aXRhZSBzYXBp\\nZW4gdXQgbGliZXJvIHZlbmVuYXRpcyBmYXVjaWJ1cy4gTnVsbGFtIHF1aXMg\\nYW50ZS4gRXRpYW0gc2l0IGFtZXQgb3JjaSBlZ2V0IGVyb3MgZmF1Y2lidXMg\\ndGluY2lkdW50LiBEdWlzIGxlby4gU2VkIGZyaW5naWxsYSBtYXVyaXMgc2l0\\nIGFtZXQgbmliaC4gRG9uZWMgc29kYWxlcyBzYWdpdHRpcyBtYWduYS4K\\n\"}]", :headers => {'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type' => 'application/json', 'User-Agent' => 'Ruby'}).
      to_return(:status => 200, :body => '', :headers => {})
  end
end
