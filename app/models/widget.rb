class Widget < ApplicationRecord
  belongs_to :room
  belongs_to :knxmodule
  has_many :rules, dependent: :destroy

  validates_uniqueness_of :knxmodule_id, message: "This knx-module has already a widget"
end
