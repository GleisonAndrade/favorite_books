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

end
