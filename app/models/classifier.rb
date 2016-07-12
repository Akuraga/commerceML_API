class Classifier < ApplicationRecord
  belongs_to :owner
  belongs_to :commerce_information
  has_many :groups, as: :groupable, dependent: :destroy
  has_many :properties
  has_many :catalogs
  has_many :offers
end
