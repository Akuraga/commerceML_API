class IdentityCard < ApplicationRecord
  belongs_to :physical_persone, optional: true
end
