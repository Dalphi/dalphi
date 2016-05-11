module ApplicationHelper
  def bootstrap_class_for(flash_type)
    return 'alert-info' if flash_type.eql?('notice')
    return 'alert-success' if flash_type.eql?('success')
    return 'alert-danger' if flash_type.eql?('error')
    return 'alert-danger' if flash_type.eql?('alert')
    flash_type.to_s
  end

  def bootstrap_title_for(flash_type)
    return fa_icon('info-circle') if flash_type.eql?('notice')
    return fa_icon('check-circle') if flash_type.eql?('success')
    return fa_icon('exclamation-circle') if flash_type.eql?('error')
    return fa_icon('exclamation-circle') if flash_type.eql?('alert')
  end
end
