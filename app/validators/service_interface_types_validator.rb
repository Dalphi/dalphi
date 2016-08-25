class ServiceInterfaceTypesValidator < ActiveModel::Validator

  def initialize(_model)
  end

  def self.validate(record)
    if %w(iterate).include?(record.role) && record.interface_types == []
      error_message = I18n.t('activerecord.errors.models.service.attributes.' \
                             'interface_types.is_empty')

    elsif %w(machine_learning merge).include?(record.role) && record.interface_types != []
      error_message = I18n.t('activerecord.errors.models.service.attributes.' \
                             'interface_types.not_empty')
    end

    record.errors[:interface_types] << error_message if error_message
  end

end
