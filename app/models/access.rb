class Access < ApplicationRecord
  belongs_to :user
  belongs_to :org_unit
end
