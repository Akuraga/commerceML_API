class ProductRequisite < ApplicationRecord
  belongs_to :product
  belongs_to :requisite
end
