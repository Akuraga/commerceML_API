class Storage < ApplicationRecord
  has_many :proposals_storages
  has_many :proposals, through: :proposals_storages
end
