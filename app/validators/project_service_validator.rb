class ProjectServiceValidator < ActiveModel::Validator

  def initialize(_model)
  end

  def self.validate_bootstrap_service(record)
    validate_service(record, 'bootstrap_service')
  end

  def self.validate_machine_learning_service(record)
    validate_service(record, 'machine_learning_service')
  end

  def self.validate_merge_service(record)
    validate_service(record, 'merge_service')
  end

  def self.validate_service(record, type)
    target_service = record.send(type)
    raise 'wrong service' if target_service && target_service.role != type[0..-9]
  rescue
    error_message = I18n.t("activerecord.errors.models.project.attributes.#{type}.no_service")
    record.errors[type.to_sym] << error_message
  end
end
