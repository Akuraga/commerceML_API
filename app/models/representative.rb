class Representative < ApplicationRecord
  has_many :contacts, as: :contactable, dependent: :destroy
  belongs_to :contractor
end
