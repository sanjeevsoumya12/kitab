class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :recoverable, :rememberable, :validatable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable
  validates :email, presence: true, on: :create
  validates :password, presence: true, on: :create
  validates :username, presence: true, on: :create
  validates :phn_number, presence: true, on: :create
  validates :date_of_birth, presence: true, on: :create

  def generate_jwt
    JWT.encode({ id: id, exp: 60.days.from_now.to_i }, Rails.application.secrets.secret_key_base)
  end
end
