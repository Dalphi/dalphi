class ServiceInterfaceTypesValidator < ActiveModel::Validator

  def initialize(_model)
  end

  def self.validate(record)
    if %w(machine_learning merge).include?(record.role) && record.interface_types != []
      error_message = I18n.t('activerecord.errors.models.service.attributes.url.badHttpResponse')
      record.errors[:interface_types] << error_message
    end
  end

end
