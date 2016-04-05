class ApplicationRecord < ActiveRecord::Base
  attr_accessible nil
  self.abstract_class = true
end
