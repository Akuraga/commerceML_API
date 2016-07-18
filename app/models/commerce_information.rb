class CommerceInformation < ApplicationRecord
  has_many :classifiers, dependent: :destroy
  has_many :catalogs, dependent: :destroy
  has_many :offers, dependent: :destroy
  has_many :documents, dependent: :destroy
end
