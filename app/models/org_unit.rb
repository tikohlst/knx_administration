class OrgUnit < ApplicationRecord
  has_many :accesses, dependent: :destroy
  has_many :users, through: :accesses
end
