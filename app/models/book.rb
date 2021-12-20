class Book < ApplicationRecord
  belongs_to :author
  validates :title, presence: { message: "  must be given please" }
  validates :price, presence: true, :numericality => { :greater_than_or_equal_to => 0 }
  validates :publishing_date, presence: true
end
