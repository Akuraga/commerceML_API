class Owner < ApplicationRecord

  has_many :catalogs
  has_many :classifiers
  has_many :payment_account
  has_many :offers

end
