class CommerceInformation < ApplicationRecord
  has_many :classifiers
  has_many :catalogs
  has_many :offers
  has_many :documents
end
