FactoryBot.define do
  factory :admin, class: User do
    name { "Admin" }
    email { "admin@favorite_books.com" }
    profile { :admin }
    password { "12345678" }
    password_confirmation { "12345678" }
  end

  factory :librarian, class: User do
    name { Faker::Name.name }
    email { "librarian@favorite_books.com" }
    profile { :librarian }
    password { "12345678" }
    password_confirmation { "12345678" }
  end

  factory :read, class: User do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    profile { :read }
    password { "12345678" }
    password_confirmation { "12345678" }
  end
end
