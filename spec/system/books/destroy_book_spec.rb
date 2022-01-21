require "rails_helper"


RSpec.describe "deleting books", :type => :system do
  let(:reader_user) { create(:reader) }
  let(:librarian_user) { create(:librarian) }
  let(:admin_user) { create(:admin) }

  let(:book) { create(:book) }

  scenario 'without permission', js: true do
    login_as(reader_user)

    expect(book.present?).to eq(true)
    expect(Book.actives.size).to eq(1)

    visit books_path

    have_book(book)

    expect(page).to_not have_link('', href: "/books/#{book.id}", class: 'btn btn-outline-danger')

    visit edit_book_path(book)
    
    expect(page).to_not have_link('Excluír', href: "/books/#{book.id}", class: 'btn btn-danger') 
  end

  scenario 'with book already deleted' do
    login_as(admin_user)

    book.remove(admin_user)
    expect(book.inactive?).to eq(true)

    visit books_path

    expect(page).to have_content('Status')
    expect(page).to have_content(book.title)
    expect(page).to have_content(book.author)
    expect(page).to have_content(book.page_count)
    expect(page).to have_content("#{I18n.l book.created_at, format: "%d de %B"}#{ I18n.l book.created_at, format: "%H:%M" }") # without \n in datetime separation
    expect(page).to have_content(book.status_text)

    expect(page).to_not have_link('', href: "/books/#{book.id}", class: 'btn btn-outline-danger')

    visit edit_book_path(book) # Don't access this page

    expect(page.current_path).to eq books_path
    expect(page).to have_content("Você não está autorizado a realizar esta ação.")
  end

  scenario 'with book active in book list', js: true do
    login_as(librarian_user)

    expect(book.present?).to eq(true)
    expect(Book.actives.size).to eq(1)

    visit books_path

    have_book(book)

    expect(page).to have_link('', href: "/books/#{book.id}", class: 'btn btn-outline-danger')

    accept_alert do
      click_link('', href: "/books/#{book.id}",class: 'btn btn-outline-danger')
    end

    book.reload

    have_not_book(book, with_title: false)

    expect(Book.actives.size).to eq(0)
    expect(page.current_path).to eq books_path
    expect(page).to have_content("O livro #{book.title} foi excluído com sucesso.")


  end

  scenario 'with book active in book edit', js: true do
    login_as(librarian_user)

    expect(book.present?).to eq(true)
    expect(Book.actives.size).to eq(1)

    visit edit_book_path(book)
    expect(page).to have_content('Editar Livro')
    # have_book(book)

    expect(page).to have_link('Excluír', href: "/books/#{book.id}", class: 'btn btn-danger')

    accept_alert do
      click_link('Excluír', href: "/books/#{book.id}", class: 'btn btn-danger')
    end

    book.reload

    have_not_book(book, with_title: false)

    expect(Book.actives.size).to eq(0)
    expect(page.current_path).to eq books_path
    expect(page).to have_content("O livro #{book.title} foi excluído com sucesso.")
  end
end

