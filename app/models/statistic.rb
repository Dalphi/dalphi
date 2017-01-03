class Statistic < ApplicationRecord
  include Swagger::Blocks

  swagger_schema :Statistic do
    key :required,
        [
          :key
        ]

    property :id do
      key :description, I18n.t('api.statistic.description.id')
      key :type, :integer
      key :example, 1
    end

    property :key do
      key :description, I18n.t('api.statistic.description.key')
      key :type, :string
      key :example, 'confidence'
    end

    property :value do
      key :description, I18n.t('api.statistic.description.value')
      key :type, :string
      key :example, '0.123456789'
    end

    property :iteration_index do
      key :description, I18n.t('api.statistic.description.iteration_index')
      key :type, :integer
      key :example, 23
    end

    property :project_id do
      key :description, I18n.t('api.statistic.description.project_id')
      key :type, :integer
      key :example, 1
    end
  end

  belongs_to :project

  validates :key,
            presence: true

  validates_uniqueness_of :key,
                          scope: [:iteration_index, :project]

  def relevant_attributes
    {
      id: id,
      key: key,
      value: value,
      iteration_index: iteration_index,
      project_id: project_id
    }
  end
end
