class Contractor < ApplicationRecord
  has_many :representatives
  has_and_belongs_to_many :documents
  belongs_to :personable, polymorphic: true
  has_many :contacts, as: :contactable, dependent: :destroy
end
