class KnxModule < ApplicationRecord
  has_one :widget, dependent: :destroy
end
