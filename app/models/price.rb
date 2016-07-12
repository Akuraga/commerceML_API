class Price < ApplicationRecord
  belongs_to :proposal
  belongs_to :price_type
end
