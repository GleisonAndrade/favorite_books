
admin = User.where(:name => 'Admin', :email => 'admin@favoritebooks.com', :profile => 'admin').first_or_create(
  :password => '12345678'
)

require 'json'

file = File.read('public/data/books.json')
books_hash = JSON.parse(file)

books_hash.each do |hash|
  Book.where(
    title: hash['title'], 
    description: hash['shortDescription'], 
    image_url: hash['thumbnailUrl'], 
    page_count: hash['pageCount'], 
    author: hash['authors']&.first
  ).first_or_create
end


