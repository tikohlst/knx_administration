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

  # Überprüft vor dem Speichern, ob es mind. einen Admin gibt
  validate :atleast_one_admin

  # Überprüft vor dem Speichern, ob mind. eine Rolle ausgewählt wurde
  validate :atleast_one_role

  def atleast_one_role
    errors.add(:base, "The user must have one role.") if self.roles.count < 1
  end

  def atleast_one_admin
    results = ActiveRecord::Base.connection.execute("SELECT user_id FROM users_roles
                                                     WHERE role_id=1 LIMIT 1;")
    errors.add(:base, "There must be one admin.") if results.size < 1
  end

end
