class ProjectServiceValidator < ActiveModel::Validator

  def initialize(_model)
  end

  def self.validate_active_learning_service(record)
    validate_service(record, 'active_learning_service')
    #   if record.active_learning_service
    #     active_learning_service = Service.find(record.active_learning_service)
    #     if active_learning_service.role != 0
    #       error_message = I18n.t('activerecord.errors.models.project.attributes.active_learning_service.wrong_service')
    #       record.errors[active_learning_service] << error_message
    #     end
    #   end
    # rescue
    #   error_message = I18n.t('activerecord.errors.models.project.attributes.active_learning_service.no_service')
    #   record.errors[:active_learning_service] << error_message
  end

  def self.validate_bootstrap_service(record)
    validate_service(record, 'bootstrap_service')
  end

  def self.validate_machine_learning_service(record)
    validate_service(record, 'machine_learning_service')
  end

  def self.validate_service(record, type)
    target_role = 'active_learning' if type == 'active_learning_service'
    target_role = 'bootstrap' if type == 'bootstrap_service'
    target_role = 'machine_learning' if type == 'machine_learning_service'
    target_service_id = record.send(type)

    if target_service_id && !target_service_id.nil?
      current_service = Service.find(target_service_id)
      if current_service.role != target_role
        error_message = I18n.t("activerecord.errors.models.project.attributes.#{type}.wrong_service")
        record.errors[type.to_sym] << error_message
      end
    end
  rescue
    error_message = I18n.t("activerecord.errors.models.project.attributes.#{type}.no_service")
    record.errors[type.to_sym] << error_message
  end
end
