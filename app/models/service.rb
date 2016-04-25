class Service < ApplicationRecord
   enum roll: [ :active_learning, :bootstrap, :machine_learning ]
   enum capability: [ :ner ]
end
