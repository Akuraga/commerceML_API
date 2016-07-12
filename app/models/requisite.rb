class Requisite < ApplicationRecord
  has_many :product_requisites
  has_many :products, through: :product_requisites

  #document
  has_many :document_requisites
  has_many :documents, through: :document_requisites
end
