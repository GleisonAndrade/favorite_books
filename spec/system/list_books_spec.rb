require "rails_helper"

RSpec.describe "listing books", :type => :system do
  let(:reader_user) { create(:reader) }
  let(:librarian_user) { create(:librarian) }
  let(:admin_user) { create(:admin) }
  let(:user_with_favorite_books) { create(:user_with_favorite_books) }
  let(:books) { create_list(:book, 10) }
  let(:book) { create(:book) }

  scenario 'with reader user with pagination' do

    login_as(reader_user)

    book_count = books.size
    expect(book_count).to eq(10)

    visit books_path

    expect(page).to have_content('Livros')
    expect(page).to have_field('contains_text')
    expect(page).to have_field('with_author')
    expect(page).to have_field('order_by')
    expect(page).to have_content("1 - 5\n de \n#{book_count}")

    expect(page).to_not have_content('Status')

    expect(page).to have_selector("#nav-bar-books")
    expect(page).to have_selector("#orders-table-tab-content")
    expect(page).to have_selector(:css, 'nav ul.pagination')
    
    book = books.last
    
    expect(page).to have_content(book.title)
    expect(page).to have_content(book.author)
    expect(page).to have_content(book.page_count)
    expect(page).to have_content("#{I18n.l book.created_at, format: "%d de %B"}\n#{ I18n.l book.created_at, format: "%H:%M" }")

    expect(page).to have_link('', href: "/books/#{book.id}/favorite")
    expect(page).to_not have_link('', href: "/books/#{book.id}/edit")
    expect(page).to_not have_link('', href: "/books/#{book.id}", class: 'btn btn-outline-danger')
  end

  scenario 'with librarian user with pagination' do
    login_as(librarian_user)

    book_count = books.size
    expect(book_count).to eq(10)

    visit books_path

    expect(page).to have_content('Livros')
    expect(page).to have_field('contains_text')
    expect(page).to have_field('with_author')
    expect(page).to have_field('order_by')
    expect(page).to have_content("1 - 5\n de \n#{book_count}")

    expect(page).to_not have_content('Status')

    expect(page).to_not have_selector("#nav-bar-books")
    expect(page).to have_selector("#orders-table-tab-content")
    expect(page).to have_selector(:css, 'nav ul.pagination')
    
    book = books.last
    
    expect(page).to have_content(book.title)
    expect(page).to have_content(book.author)
    expect(page).to have_content(book.page_count)
    expect(page).to have_content("#{I18n.l book.created_at, format: "%d de %B"}\n#{ I18n.l book.created_at, format: "%H:%M" }")

    expect(page).to_not have_link('', href: "/books/#{book.id}/favorite")
    expect(page).to have_link('', href: "/books/#{book.id}/edit")
    expect(page).to have_link('', href: "/books/#{book.id}", class: 'btn btn-outline-danger')
  end

  scenario 'with admin user with pagination' do
    login_as(admin_user)

    book_count = books.size
    expect(book_count).to eq(10)

    visit books_path

    expect(page).to have_content('Livros')
    expect(page).to have_field('contains_text')
    expect(page).to have_field('with_author')
    expect(page).to have_field('order_by')
    expect(page).to have_content("1 - 5\n de \n#{book_count}")

    expect(page).to have_content('Status')

    expect(page).to_not have_selector("#nav-bar-books")
    expect(page).to have_selector("#orders-table-tab-content")
    expect(page).to have_selector(:css, 'nav ul.pagination')

    
    book = books.last
    
    expect(page).to have_content(book.title)
    expect(page).to have_content(book.author)
    expect(page).to have_content(book.page_count)
    expect(page).to have_content("#{I18n.l book.created_at, format: "%d de %B"}\n#{ I18n.l book.created_at, format: "%H:%M" }")

    expect(page).to_not have_link('', href: "/books/#{book.id}/favorite")
    expect(page).to have_link('', href: "/books/#{book.id}/edit")
    expect(page).to have_link('', href: "/books/#{book.id}", class: 'btn btn-outline-danger')
  end

  scenario 'with reader user without pagination' do

    login_as(reader_user)

    expect(book.present?).to eq(true)

    visit books_path

    expect(page).to have_content('Livros')
    expect(page).to have_field('contains_text')
    expect(page).to have_field('with_author')
    expect(page).to have_field('order_by')
    expect(page).to have_content("\n1")

    expect(page).to_not have_content('Status')

    expect(page).to have_selector("#nav-bar-books")
    expect(page).to have_selector("#orders-table-tab-content")
    expect(page).to_not have_selector(:css, 'nav ul.pagination') # without pagination

    
    expect(page).to have_content(book.title)
    expect(page).to have_content(book.author)
    expect(page).to have_content(book.page_count)
    expect(page).to have_content("#{I18n.l book.created_at, format: "%d de %B"}\n#{ I18n.l book.created_at, format: "%H:%M" }")

    expect(page).to have_link('', href: "/books/#{book.id}/favorite")
    expect(page).to_not have_link('', href: "/books/#{book.id}/edit")
    expect(page).to_not have_link('', href: "/books/#{book.id}", class: 'btn btn-outline-danger')
  end

  scenario 'with reader user applying sorting' do

    login_as(reader_user)

    book_count = books.size
    expect(book_count).to eq(10)
    
    options = ["OrderByCreatedAtDesc", "OrderByCreatedAtAsc", "OrderByTitleAsc", "OrderByTitleDesc"]

    visit books_path

    options.each do |option|
      order_by(option)
    end    
  end

  scenario 'with reader user applying filter with_author' do

    login_as(reader_user)

    book_count = books.size
    expect(book_count).to eq(10)

    visit books_path

    authors = books.pluck(:author)

    authors.each do |author|
      with_author(author)
    end    
  end

  scenario 'with reader user applying filter contains_text' do

    login_as(reader_user)

    book_count = books.size
    expect(book_count).to eq(10)

    visit books_path

    titles = books.pluck(:title)

    titles.each do |title|
      contains_text(title)
    end

    descriptions = books.pluck(:description)

    descriptions.each do |description|
      contains_text(description)
    end    
  end

  scenario 'with reader user applying filter tab favorites' do

    login_as(user_with_favorite_books)

    book_count = books.size
    expect(book_count).to eq(10)

    favorite_books_count = user_with_favorite_books.books.size
    expect(favorite_books_count).to eq(5)

    visit books_path

    click_link 'Favoritos', class: 'flex-sm-fill text-sm-center nav-link'

    books_search = Book.favorite_books(user_with_favorite_books).order(created_at: :desc).limit(5).offset(0)
    expect(books_search.size).to eq(5)
    expect(page).to have_content(books_to_string(books_search))  
  end

  def order_by(option_value)
    options = {
      "OrderByCreatedAtDesc": "Recentemente adicionado",
      "OrderByCreatedAtAsc": "Mais antigo",
      "OrderByTitleAsc": "Título A-Z",
      "OrderByTitleDesc": "Título Z-A"
    }

    select(options[option_value.to_sym], from: 'order_by')

    books_search = Book.order_by(option_value).limit(5).offset(0)
    expect(page).to have_content(books_to_string(books_search))

    click_link '2', class: 'page-link'

    books_search = Book.order_by(option_value).limit(5).offset(5)
    expect(page).to have_content(books_to_string(books_search))
  end

  def with_author(author)
    fill_in 'with_author', with: author

    books_search = Book.with_author(author).order(created_at: :desc).limit(5).offset(0)
    expect(page).to have_content(books_to_string(books_search))
  end

  def contains_text(text)
    fill_in 'contains_text', with: text

    books_search = Book.contains_text(text).order(created_at: :desc).limit(5).offset(0)
    expect(page).to have_content(books_to_string(books_search))
  end

  def books_to_string(books)
    string_books = ""

    books.each do |book|
      string_books = string_books + "#{book.title} #{book.author} #{book.page_count} #{I18n.l book.created_at, format: "%d de %B"}\n#{ I18n.l book.created_at, format: "%H:%M" }\n"
    end

    string_books
  end
end
