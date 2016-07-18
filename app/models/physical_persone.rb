class PhysicalPersone < ApplicationRecord
  has_many :contractors, as: :personable
  has_one :identity_card
end
