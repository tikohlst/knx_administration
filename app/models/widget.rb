class Widget < ApplicationRecord
  belongs_to :room
  belongs_to :knx_module
  has_many :rules, dependent: :destroy

  accepts_nested_attributes_for :rules, allow_destroy: true

  validates_uniqueness_of :knx_module_id, message: "This knx-module has already a widget"
end
