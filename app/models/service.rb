class Service < ApplicationRecord
  include UrlResponseChecker

  enum role: [ :active_learning, :bootstrap, :machine_learning ]
  enum problem_id: [ :ner ]

  has_many :projects

  validates :role, :problem_id, :url, :title, :version,
    presence: true

  validates :url,
    format: {
      with: /http(|s)\:\/\/\S+/,
      message: I18n.t('activerecord.errors.models.service.attributes.url.regex_mismatch')
    }

  validate do |service|
    if service.url
      HttpResponseValidator.validate(service)
    end
  end

  def self.new_from_url(url)
    Service.new(params_from_url(url))
  rescue
    false
  end

  def self.params_from_url(url)
    data = URI.parse(url).read
    JSON.parse(data)
  end
end
