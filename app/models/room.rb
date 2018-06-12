class Room < ApplicationRecord
  has_many :administrate, dependent: :destroy
  has_many :users, through: :administrate
  has_many :widgets, dependent: :destroy
end
