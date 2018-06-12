class KnxModule < ApplicationRecord
  belongs_to :widget, dependent: :destroy
end
