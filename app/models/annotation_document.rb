class AnnotationDocument < ApplicationRecord
  belongs_to :raw_datum
  has_attached_file :content

  enum type: [ :text_nominal ]
  serialize :options, Array
end
