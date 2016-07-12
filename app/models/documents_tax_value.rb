class DocumentsTaxValue < ApplicationRecord
  belongs_to :document
  belongs_to :tax
end
