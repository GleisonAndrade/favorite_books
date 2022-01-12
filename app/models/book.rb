class Book < ApplicationRecord
  validates :title, :description, :image_url, :page_count, :author, presence: true
  validates :title, :description, :author, length: { minimum: 3 }
  validates :page_count, numericality: { page_count: true, greater_than: 0 }
end
