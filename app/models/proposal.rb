class Proposal < ApplicationRecord
  belongs_to :product
  has_many :proposals_storages
  has_many :storages, through: :proposals_storages
  has_many :prices
end
