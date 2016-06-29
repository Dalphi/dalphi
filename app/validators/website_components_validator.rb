class WebsiteComponentsValidator < ActiveModel::Validator

  def initialize(_model)
  end

  def self.validate_stylesheet(record)
    return if record.stylesheet.nil?

    sass_engine = Sass::Engine.new(record.stylesheet, syntax: :scss)
    sass_engine.render
  rescue Sass::SyntaxError
    error_message = I18n.t('activerecord.errors.models.interface.attributes.stylesheet.syntax-error')
    record.errors['stylesheet'] << error_message
  end

  def self.validate_java_script(record)
    return if record.java_script.nil?

    CoffeeScript.compile record.java_script
  rescue ExecJS::RuntimeError
    error_message = I18n.t('activerecord.errors.models.interface.attributes.java_script.syntax-error')
    record.errors['java_script'] << error_message
  end
end
