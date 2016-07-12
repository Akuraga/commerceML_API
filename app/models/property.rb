class Property < ApplicationRecord
  has_many :handbooks
  belongs_to :classifier
  has_many :product_properties
  has_many :products, through: :product_properties
end
