class ProductAttributeValue < ApplicationRecord
  belongs_to :product_attribute
  belongs_to :product

end
