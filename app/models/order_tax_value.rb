class OrderTaxValue < ApplicationRecord
  belongs_to :product
  belongs_to :tax
end

