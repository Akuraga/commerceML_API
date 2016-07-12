class LegalEntity < ApplicationRecord
  has_many :contractors, as: :personable
end
