module ApplicationHelper
  def bootstrap_class_for(flash_type)
    return 'alert-info' if flash_type.eql?('notice')
    return 'alert-success' if flash_type.eql?('success')
    return 'alert-danger' if flash_type.eql?('error')
    return 'alert-danger' if flash_type.eql?('alert')
    flash_type.to_s
  end

  def icon_name_for(flash_type)
    return 'info-circle' if flash_type.eql?('notice')
    return 'check-circle' if flash_type.eql?('success')
    return 'exclamation-triangle' if flash_type.eql?('error')
    return 'exclamation' if flash_type.eql?('alert')
  end

  # this method smells of :reek:ControlParameter
  def boolean_icon(boolean_value)
    return fa_icon('check') if boolean_value
    fa_icon('times')
  end
end
