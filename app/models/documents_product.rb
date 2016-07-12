class DocumentsProduct < ApplicationRecord
  belongs_to :document
  belongs_to :product
end
