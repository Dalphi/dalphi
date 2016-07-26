class ProjectInterfacesValidator < ActiveModel::Validator
  def initialize(_model)
  end

  def self.validate(record)
    interface_types = record.interfaces.map(&:interface_type)
    if interface_types != interface_types.uniq
      error_message = I18n.t('activerecord.errors.models.project.attributes.interfaces.not_unique')
      record.errors[:interfaces] << error_message
    end
  end
end
