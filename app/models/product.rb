class Product < ApplicationRecord
  belongs_to :unit

  belongs_to :catalog, optional: true

  has_and_belongs_to_many :groups

  #properties
  has_many :product_properties, dependent: :destroy
  has_many :properties, through: :product_properties

  #tax
  has_many :product_tax_values
  has_many :taxes, through: :product_tax_values

  #requisite
  has_many :product_requisites
  has_many :requisites, through: :product_requisites

  #attribute
  has_many :product_attribute_values
  has_many :product_attributes, through: :product_attribute_values

  #proposal
  has_one :proposal

  #images
  has_many :product_images, dependent: :destroy

  #handbooks
  has_and_belongs_to_many :handbooks

  #documents (order)
  has_many :documents_products
  has_many :documents, through: :documents_products

  has_many :order_tax_values, dependent: :destroy
  has_many :taxes, through: :order_tax_values

  #discounts
  has_many :discounts, dependent: :destroy
end
