class ProposalsStorage < ApplicationRecord
  belongs_to :proposal
  belongs_to :storage
end
