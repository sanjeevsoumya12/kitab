class Author < ApplicationRecord
  has_many :books, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: "must be a valid email address" }, uniqueness: true
  validates :phn_number, presence: true, numericality: true, length: { minimum: 10, maximum: 15 }
end
