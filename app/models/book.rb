class Book < ApplicationRecord
  validates :title, :description, :image_url, :page_count, :author, presence: true
  validates :author, length: { minimum: 3 }
end
