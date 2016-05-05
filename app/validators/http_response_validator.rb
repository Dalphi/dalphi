class HttpResponseValidator < ActiveModel::Validator
  include UrlResponseChecker

  def initialize(_model)
  end

  def self.add_error_to(record, url)
    error_message = I18n.t('activerecord.errors.models.service.attributes.url.badHttpResponse')
    record.errors[url] << error_message
  end

  def self.validate(record)
    url = record.url

    if !UrlResponseChecker::check_response url
      add_error_to record, url
    end
  end
end
