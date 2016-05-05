class Service < ApplicationRecord
  include UrlResponseChecker

  enum role: [ :active_learning, :bootstrap, :machine_learning ]
  enum problem_id: [ :ner ]

  validates :role, :description, :problem_id, :url, :title, :version,
    presence: true

  validates :url,
    format: {
      with: /http(|s)\:\/\/\S+/,
      message: I18n.t('activerecord.errors.models.service.attributes.url.regex_mismatch')
    }

  validate do |service|
    HttpResponseValidator.validate(service)
  end

  def self.new_from_url(url)
    Service.new(params_from_url(url))
  rescue
    false
  end

  def self.params_from_url(url)
    url = URI.parse(url)
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
    end
    JSON.parse(res.body.to_s)
  end
end
