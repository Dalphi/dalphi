class WebsiteComponentsValidator < ActiveModel::Validator

  def initialize(_model)
  end

  def self.validate_stylesheet(record)
    return if record.stylesheet.path.nil?

    container_class = Rails.configuration.x.dalphi['annotation-interface']['container-class-name']
    stylesheet_contents = Paperclip.io_adapters.for(record.stylesheet).read
    nested_stylesheet = ".#{container_class} { #{stylesheet_contents} }"
    sass_engine = Sass::Engine.new(nested_stylesheet, syntax: :scss)
    compilate = sass_engine.render
    record.set_validator_compiled_stylesheet = compilate

  rescue Sass::SyntaxError
    error_message = I18n.t('activerecord.errors.models.interface.attributes' \
                           '.stylesheet.syntax-error')
    record.errors['stylesheet'] << error_message
  end

  def self.validate_java_script(record)
    return if record.java_script.path.nil?

    compilate = CoffeeScript.compile(Paperclip.io_adapters.for(record.java_script).read)
    record.set_validator_compiled_java_script = compilate

  rescue ExecJS::RuntimeError
    error_message = I18n.t('activerecord.errors.models.interface.attributes' \
                           '.java_script.syntax-error')
    record.errors['java_script'] << error_message
  end
end
