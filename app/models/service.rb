class Service < ApplicationRecord
  include UrlResponseChecker
  include Swagger::Blocks

  swagger_schema :Service do
    property :role do
      key :type, :string
    end

    property :title do
      key :type, :string
    end

    property :description do
      key :type, :string
    end

    property :problem_id do
      key :type, :string
    end

    property :url do
      key :type, :string
    end

    property :version do
      key :type, :string
    end
  end

  enum role: [ :active_learning, :bootstrap, :machine_learning, :merge ]
  enum problem_id: [ :ner ]

  has_many :projects

  validates :role, :problem_id, :url, :title, :version,
    presence: true

  validates :url,
    uniqueness: true,
    format: {
      with: /\Ahttp(|s)\:\/\/\S+\z/,
      message: I18n.t('activerecord.errors.models.service.attributes.url.regex_mismatch')
    }

  validate do |service|
    HttpResponseValidator.validate(service) if service.url
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

  def is_available?
    UrlResponseChecker::check_response url
  end
end
