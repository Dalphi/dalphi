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

    property :version do
      key :type, :string
    end
  end

  enum role: [:iterate, :merge, :machine_learning]

  has_many :projects
  has_and_belongs_to_many :interface_types

  validates :role, :url, :title, :version,
    presence: true

  validates :problem_id,
    presence: true,
    format: { with: /\A[\w\.\-\_]+\z/ }

  validates :url,
    uniqueness: true,
    format: {
      with: /\Ahttp(|s)\:\/\/\S+\z/,
      message: I18n.t('activerecord.errors.models.service.attributes.url.regex_mismatch')
    }

  validate do |service|
    HttpResponseValidator.validate(service) if service.url
    ServiceInterfaceTypesValidator.validate(service)
  end

  def self.new_from_url(url)
    Service.new(params_from_url(url))
  rescue
    false
  end

  def self.params_from_url(url)
    timeout = 3
    Timeout::timeout(timeout) do
      data = JSON.parse(URI.parse(url).read)
      data['url'] = url
      return data
    end
  rescue
    raise "timeout of #{timeout} seconds to look up service exceeded"
  end

  def is_available?
    UrlResponseChecker::check_response self.url
  end

  def label
    self.title
  end

  def self.problem_identifiers
    Service.distinct.pluck(:problem_id)
  end
end
