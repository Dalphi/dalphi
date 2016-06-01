class AnnotationDocumentValidator < ActiveModel::Validator

  def initialize(_model)
  end

  def self.validate_chunk_offset_upper_limit(record)
    offset = record.chunk_offset
    raw_datum = record.raw_datum
    return if offset.nil? || raw_datum.nil? # this is hadeled by dynamic_matchers

    if offset > raw_datum.size?
      error_message = I18n.t('activerecord.errors.models.annotation_document.' \
                             'attributes.chunk_offset.too_large')
      record.errors[:chunk_offset] << error_message
    end
  end

  def self.validate_options_array(record)
    array = record.options

    if array == []
      error_message = I18n.t('activerecord.errors.models.annotation_document.' \
                             'attributes.options.empty')
      record.errors[:options] << error_message
    end

    if array.count < 2
      error_message = I18n.t('activerecord.errors.models.annotation_document.' \
                             'attributes.options.too-few-options')
      record.errors[:options] << error_message
    end

    array.each do |option|
      if option.class != String
        error_message = I18n.t('activerecord.errors.models.annotation_document.' \
                               'attributes.options.type')
        record.errors[:options] << error_message
        break
      end
    end
  end

  def self.validate_content(record)
    raw_datum = record.raw_datum
    return if raw_datum.nil? # this is hadeled by dynamic_matchers

    raw_datum_shape = raw_datum.shape.to_sym
    shape_conform_mime_types = RawDatum::MIME_TYPES[raw_datum_shape]
    content_type = record.content_content_type

    if !shape_conform_mime_types.include? content_type
      error_message = I18n.t('activerecord.errors.models.annotation_document.' \
                             'attributes.content.type')
      record.errors[:options] << error_message
    end
  end

  def self.validate_label(record)
    label = record.label
    return if label.nil? || label.empty?

    options = record.options

    if !options.include? label
      error_message = I18n.t('activerecord.errors.models.annotation_document.' \
                             'attributes.label.not-in-options')
      record.errors[:label] << error_message
    end
  end
end
