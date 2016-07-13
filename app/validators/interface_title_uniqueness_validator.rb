class InterfaceTitleUniquenessValidator < ActiveModel::Validator

  def initialize(_model)
  end

  def self.validate_title_uniqueness(record)
    interfaces_with_same_title = Interface.where(title: record.title)
                                          .where.not(id: record)
    return unless interfaces_with_same_title.any?
    interfaces_with_same_title.each do |interface|
      next if record.associated_problem_identifiers & interface.associated_problem_identifiers == []
      return record.errors['title'] << I18n.t('activerecord.errors.models.interface.attributes' \
                                              '.title.uniqueness')
    end
  end
end
