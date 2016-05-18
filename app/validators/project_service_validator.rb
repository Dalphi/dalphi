class ProjectServiceValidator < ActiveModel::Validator

  def initialize(_model)
  end

  def self.validate_active_learning_service(record)
    validate_service(record, 'active_learning_service')
  end

  def self.validate_bootstrap_service(record)
    validate_service(record, 'bootstrap_service')
  end

  def self.validate_machine_learning_service(record)
    validate_service(record, 'machine_learning_service')
  end

  def self.validate_service(record, type)
    target_service = record.send(type)
    if target_service && target_service.role != type[0..-9]
      error_message = I18n.t("activerecord.errors.models.project.attributes.#{type}.wrong_service")
      record.errors[type.to_sym] << error_message
    end
  rescue
    error_message = I18n.t("activerecord.errors.models.project.attributes.#{type}.no_service")
    record.errors[type.to_sym] << error_message
  end
end
