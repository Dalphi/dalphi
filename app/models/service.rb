class Service < ApplicationRecord
   enum role: [:active_learning, :bootstrap, :machine_learning]
   enum capability: [:ner]
end
