class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :administrates, dependent: :destroy
  has_many :rooms, through: :administrates

  accepts_nested_attributes_for :administrates, allow_destroy: true

end
