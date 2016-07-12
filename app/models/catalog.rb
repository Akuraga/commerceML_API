class Catalog < ApplicationRecord
  belongs_to :owner
  belongs_to :classifier
  belongs_to :commerce_information
  has_many :products
  has_many :offers
end
