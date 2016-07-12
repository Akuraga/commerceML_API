class PhysicalPersone < ApplicationRecord
  has_many :contractors, as: :personable, dependent: :destroy
  has_one :identity_card
end
