json.extract! book, :id, :title, :description, :image_url, :page_count, :author, :created_at, :updated_at
json.url book_url(book, format: :json)
