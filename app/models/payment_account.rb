class PaymentAccount < ApplicationRecord
  has_many :banks
  belongs_to :owner
end
