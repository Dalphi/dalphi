class Service < ApplicationRecord
  include UrlResponseChecker

  enum roll: [ :active_learning, :bootstrap, :machine_learning ]
  enum capability: [ :ner ]

  validates :roll, :description, :capability, :url, :title, :version,
    presence: true

  validates :url,
    format: {
      with: /http(|s)\:\/\/\S+/,
      message: I18n.t('activerecord.errors.models.service.attributes.url.regex_mismatch')
    }

  validate do |service|
    HttpResponseValidator.validate(service)
  end
end
