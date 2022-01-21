FactoryBot.define do
  factory :admin, class: User do
    name { "Admin" }
    email { "admin@favoritebooks.com" }
    profile { :admin }
    password { "12345678" }
    password_confirmation { "12345678" }
  end

  factory :librarian, class: User do
    name { Faker::Name.unique.name }
    email { "librarian@favoritebooks.com" }
    profile { :librarian }
    password { "12345678" }
    password_confirmation { "12345678" }
  end

  factory :reader, class: User do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.free_email }
    profile { :reader }
    password { "12345678" }
    password_confirmation { "12345678" }
  end

  factory :user, class: User do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.free_email }
    profile { :reader }
    password { "12345678" }
    password_confirmation { "12345678" }
  end

  factory :user_with_favorite_books, class: User do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.free_email }
    profile { :reader }
    password { "12345678" }
    password_confirmation { "12345678" }

    transient do
      number_books { 5 }
    end

    after(:create) do |user, evaluator|
      create_list(:user_book, evaluator.number_books, user: user)
    end
  end
end
