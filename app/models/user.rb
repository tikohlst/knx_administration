class User < ApplicationRecord
  rolify
  resourcify

  # Relations
  has_and_belongs_to_many :roles, join_table: :users_roles

  has_many :accesses, dependent: :destroy
  has_many :org_units, through: :accesses

  accepts_nested_attributes_for :users_roles, :roles, :org_units, :accesses,  allow_destroy: true

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

  # Validate if there is at least one admin
  validate :at_least_one_admin?

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  private

  def at_least_one_admin?
    results = ActiveRecord::Base.connection.execute(
        "SELECT user_id FROM users_roles WHERE role_id=1 LIMIT 1;")
    errors.add(:base, I18n.t('errors.messages.admin')) if results.size < 1 && ENV['SEEDS'].blank?
  end

end
