class PriceTypeTaxValue < ApplicationRecord
  belongs_to :price_type
  belongs_to :tax
end
