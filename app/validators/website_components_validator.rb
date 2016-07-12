class WebsiteComponentsValidator < ActiveModel::Validator

  def initialize(_model)
  end

  def self.validate_stylesheet(record)
    return if record.stylesheet.nil?

    container_class = Rails.configuration.x.dalphi['annotation-interface']['container-class-name']
    nested_stylesheet = ".#{container_class} { #{record.stylesheet} }"
    sass_engine = Sass::Engine.new(nested_stylesheet, syntax: :scss)
    compilate = sass_engine.render
    record.set_validator_compiled_stylesheet = compilate

    ap record

  rescue Sass::SyntaxError
    error_message = I18n.t('activerecord.errors.models.interface.attributes' \
                           '.stylesheet.syntax-error')
    record.errors['stylesheet'] << error_message
  end

  def self.validate_java_script(record)
    return if record.java_script.nil?

    compilate = CoffeeScript.compile(record.java_script)
    record.set_validator_compiled_java_script = compilate

  rescue ExecJS::RuntimeError
    error_message = I18n.t('activerecord.errors.models.interface.attributes' \
                           '.java_script.syntax-error')
    record.errors['java_script'] << error_message
  end
end
