class PriceType < ApplicationRecord
  has_many :price_type_tax_values
  has_many :taxes, through: :price_type_tax_values
  has_many :prices
  belongs_to :offer
end
