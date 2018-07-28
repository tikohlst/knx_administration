class User < ApplicationRecord
  rolify
  resourcify

  # Relations
  has_and_belongs_to_many :roles, join_table: :users_roles

  accepts_nested_attributes_for :users_roles, :roles, allow_destroy: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         authentication_keys: [:username]

  # Validations
  validates :username, uniqueness: true, presence: true

  validates_presence_of :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?
  validates :password, length: { in: 6..20 }, if: :password_required?

  # Überprüft vor dem Speichern, ob es mind. einen Admin gibt
  validate :at_least_one_admin

  # Überprüft vor dem Speichern, ob mind. eine Rolle ausgewählt wurde
  validate :at_least_one_role

  def at_least_one_admin
    results = ActiveRecord::Base.connection.execute("SELECT user_id FROM users_roles
                                                     WHERE role_id=1 LIMIT 1;")
    errors.add(:base, "There must be one admin.") if results.size < 1 && ENV['SEEDS'].blank?
  end

  def at_least_one_role
    errors.add(:base, "There must be one role.") if self.roles.blank? && ENV['SEEDS'].blank?
  end

  def email_changed?
    false
  end

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

end
