class User < ApplicationRecord
  rolify

  has_many :accesses, dependent: :destroy
  has_many :org_units, through: :accesses

  accepts_nested_attributes_for :roles, :org_units, :accesses,  allow_destroy: true

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
    if not (User.with_role :admin).exists? and ENV['SEEDS'].blank?
      errors.add(:base, I18n.t('errors.messages.admin'))
    end
  end
end
