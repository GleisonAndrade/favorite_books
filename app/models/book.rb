class Book < ApplicationRecord
  has_many :users_books, dependent: :destroy
  has_many :users, through: :users_books

  accepts_nested_attributes_for :users_books

  validates :title, :description, :image_url, :page_count, :author, presence: true
  validates :title, :description, :author, length: { minimum: 3 }
  validates :page_count, numericality: { only_integer: true, greater_than: 0 }
end
