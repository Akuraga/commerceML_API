class Group < ApplicationRecord
  belongs_to :groupable, polymorphic: true
  has_many :groups, as: :groupable, dependent: :destroy
  has_and_belongs_to_many :products
  belongs_to :classifier

end
