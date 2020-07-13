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
  validates :username, uniqueness: { case_sensitive: true }, presence: true

  validates_presence_of :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?
  validates :password, length: { in: 6..20 }, if: :password_required?

  validates :language, presence: true
  validates :role_ids, presence: true, if: :seeds?
  validates :org_unit_ids, presence: true, if: :seeds?

  validate :at_least_one_admin?, if: :seeds?

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  private

  def seeds?
    ENV['SEEDS'] == "1" ? false : true
  end

  def at_least_one_admin?
    unless (User.with_role :admin).exists?
      errors.add(:base, I18n.t('errors.messages.admin'))
    end
  end
end
