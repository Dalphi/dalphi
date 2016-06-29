class WebsiteComponentsValidator < ActiveModel::Validator

  def initialize(_model)
  end

  def self.validate_stylesheet(record)
    return if record.stylesheet.nil?

    sass_engine = Sass::Engine.new(record.stylesheet, syntax: :scss)
    sass_engine.render
  rescue Sass::SyntaxError
    error_message = I18n.t('activerecord.errors.models.service.attributes.url.badHttpResponse')
    record.errors[url] << error_message
  end

  def self.validate_java_script(record)
    return if record.java_script.nil?
  end
end
