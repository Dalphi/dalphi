Swagger::Docs::Config.register_apis({
  '1.0' => {
    # the extension used for the API
    :api_extension_type => :json,
    # the output location where your .json files are written to
    :api_file_path => 'public/api/v1/',
    # the URL base path to your API
    :base_path => 'http://api.somedomain.com',
    # if you want to delete all .json files at each generation
    :clean_directory => false,
    # Ability to setup base controller for each api version. Api::V1::SomeController for example.
    :parent_controller => API::V1::BaseController,
    # add custom attributes to api-docs
    :attributes => {
      :info => {
        'title' => 'Dalphi',
        'description' => 'Dalphi - Active Learning Platform for Human Interaction',
        'license' => 'Apache 2.0',
        'licenseUrl' => 'http://www.apache.org/licenses/LICENSE-2.0.html'
      }
    }
  }
})
