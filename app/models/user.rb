class User < ApplicationRecord
  rolify
  resourcify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :administrates, dependent: :destroy
  has_many :rooms, through: :administrates

  has_and_belongs_to_many :roles, join_table: :users_roles

  accepts_nested_attributes_for :administrates, :users_roles, :roles, allow_destroy: true

end
