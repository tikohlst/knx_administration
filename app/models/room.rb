class Room < ApplicationRecord
  has_many :administrates, dependent: :destroy
  has_many :users, through: :administrates
  has_many :widgets, dependent: :destroy
end
