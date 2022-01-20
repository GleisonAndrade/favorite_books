FactoryBot.define do
  factory :user_book, class: UserBook do
    association :user, factory: :user
    association :book, factory: :book

    favorite { true }
    status { 'added' }
    pages_read { 0 }
  end
end
