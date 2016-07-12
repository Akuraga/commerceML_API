class Document < ApplicationRecord
  has_and_belongs_to_many :contractors
  has_many :documents_products
  has_many :products, through: :documents_products

  has_many :document_requisites
  has_many :requisites, through: :document_requisites

  belongs_to :commerce_information

  has_many :discounts

  #documents
  has_many :documents_tax_values
  has_many :taxes, through: :documents_tax_values
end
