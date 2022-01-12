FactoryBot.define do
  factory :book, class: Book do
    title { Faker::Book.title }
    description { Faker::Lorem.sentence }
    image_url { "https://image.com/blank.jpg" }
    page_count { Faker::Number.within(range: 1..100) }
    author { Faker::Book.author }
  end

  factory :book_invalid, class: Book do
    title { nil }
    description { "" }
    image_url { "https://image.com/blank.jpg" }
    page_count { 0 }
    author { "" }
  end
end
