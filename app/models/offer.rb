class Offer < ApplicationRecord
  belongs_to :classifier
  belongs_to :catalog
  belongs_to :owner
  belongs_to :commerce_information
  has_many :price_type

end
