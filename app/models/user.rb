class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :recoverable, :rememberable, :validatable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable, :recoverable, :confirmable
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: "must be a valid email address" }
  # validates :password, presence: true, allow_blank: true
  validates_presence_of :password_confirmation, if: -> { password.present? }
  validates_confirmation_of :password, if: -> { password.present? }
  # validates :password_confirmation, presence: true, allow_blank: true

  validates :user_name, presence: true
  validates :phn_number, presence: true
  validates :date_of_birth, presence: true
  validate :validate_age

  def generate_jwt
    JWT.encode({ id: id, exp: 60.days.from_now.to_i }, Rails.application.secrets.secret_key_base)
  end

  private

  def validate_age
    if date_of_birth.present? && date_of_birth > Time.now
      errors.add(:date_of_birth, "Invalidate date")
    end
  end
end
