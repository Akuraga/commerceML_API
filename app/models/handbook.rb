class Handbook < ApplicationRecord
  belongs_to :property
  has_and_belongs_to_many :products
end
