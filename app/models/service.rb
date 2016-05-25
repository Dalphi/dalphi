class Service < ApplicationRecord
  include UrlResponseChecker
  # include Swagger::Blocks
  #
  # swagger_schema :Pet do
  #   key :required, [:id, :name]
  #   property :id do
  #     key :type, :integer
  #     key :format, :int64
  #   end
  #   property :name do
  #     key :type, :string
  #   end
  #   property :tag do
  #     key :type, :string
  #   end
  # end
  #
  # swagger_schema :PetInput do
  #   allOf do
  #     schema do
  #       key :'$ref', :Pet
  #     end
  #     schema do
  #       key :required, [:name]
  #       property :id do
  #         key :type, :integer
  #         key :format, :int64
  #       end
  #     end
  #   end
  # end

  enum role: [ :active_learning, :bootstrap, :machine_learning ]
  enum problem_id: [ :ner ]

  has_many :projects

  validates :role, :problem_id, :url, :title, :version,
    presence: true

  validates :url,
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
