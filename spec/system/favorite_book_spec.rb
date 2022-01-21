require "rails_helper"

RSpec.describe "favorite books", :type => :system, js: true do
  let(:reader_user) { create(:reader) }
  let(:librarian_user) { create(:librarian) }
  let(:admin_user) { create(:admin) }
  let(:book) { create(:book) }

  
  scenario 'without permission (librarian)' do
    login_as(librarian_user)

    expect(book.present?).to eq(true)
    expect(Book.actives.size).to eq(1)
    expect(book.favorite?(reader_user)).to eq(false)

    add_favorite_without_permission(book, librarian_user)
  end

  scenario 'without permission (admin)' do
    login_as(admin_user)

    expect(book.present?).to eq(true)
    expect(Book.actives.size).to eq(1)
    expect(book.favorite?(reader_user)).to eq(false)

    add_favorite_without_permission(book, admin_user)
  end

  scenario 'add favorite book' do
    login_as(reader_user)

    expect(book.present?).to eq(true)
    expect(Book.actives.size).to eq(1)
    expect(book.favorite?(reader_user)).to eq(false)

    add_favorite(book, reader_user)
  end

  scenario 'add favorite book invalid' do
    login_as(reader_user)

    expect(book.present?).to eq(true)
    expect(Book.actives.size).to eq(1)
    expect(book.favorite?(reader_user)).to eq(false)

    book.page_count = 0
    book.save(validate: false)
    book.reload

    add_favorite(book, reader_user)
    book.reload

    expect(book.favorite?(reader_user)).to eq(false)
    # expect(page).to have_content("Erro ao adicionar o Livro #{book.title} nos favoritos.") # don't display messages
  end

  scenario 'remove favorite book' do
    login_as(reader_user)

    expect(book.present?).to eq(true)
    expect(Book.actives.size).to eq(1)

    book.favorite(reader_user)

    expect(book.favorite?(reader_user)).to eq(true)

    add_favorite(book, reader_user)

    expect(book.favorite?(reader_user)).to eq(false)
  end

  def add_favorite(book, user)
    visit books_path
    expect(page).to have_content('Livros')

    is_favorite = book.favorite?(user)
    is_valid = book.valid?

    have_book(book)

    find(:xpath, "//a[@href='/books/#{book.id}/favorite']").click

    wait_for_ajax

    if is_favorite
      click_link 'Favoritos', class: 'flex-sm-fill text-sm-center nav-link'
      wait_for_ajax
      
      if is_valid 
        have_not_book(book, with_page_count: false)
      else
        have_book(book)
      end
    else
      click_link 'Favoritos', class: 'flex-sm-fill text-sm-center nav-link'
      wait_for_ajax
      
      if is_valid 
        have_book(book)
      else
        have_not_book(book, with_page_count: false)
      end
    end
  end

  def add_favorite_without_permission(book, user)
    visit books_path
    expect(page).to have_content('Livros')

    have_book(book)

    expect(page).to_not have_link('', href: "/books/#{book.id}/favorite")
    expect(page).to_not have_selector("#nav-bar-books")
  end

end
