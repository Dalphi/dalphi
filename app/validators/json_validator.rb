require 'json'

class JsonValidator < ActiveModel::Validator

  def initialize(_model)
  end

  def self.validate_json(record, attribute)
    !!JSON.parse(attribute)
  rescue
    record.errors['test_payload'] << I18n.t('activerecord.errors.models.interface_type' \
                                            '.attributes.test_payload.not-json')
  end
end
