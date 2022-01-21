require "rails_helper"

RSpec.describe "updating a book", :type => :system do
  let(:reader_user) { create(:reader) }
  let(:librarian_user) { create(:librarian) }
  let(:admin_user) { create(:admin) }

  let(:book) { create(:book) }

  scenario 'without permission' do
    login_as(reader_user)

    visit edit_book_path(book)

    expect(page.current_path).to eq books_path
    expect(page).to have_content("Você não está autorizado a realizar esta ação.")
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

    expect(page).to_not have_link('', href: "/books/#{book.id}/edit", class: 'btn btn-outline-secondary')
    # expect(page).to_not have_link('', href: "/books/#{book.id}", class: 'btn btn-outline-danger')

    visit edit_book_path(book)    
    expect(page.current_path).to eq books_path
    expect(page).to have_content("Você não está autorizado a realizar esta ação.")
  end

  scenario 'with valid inputs' do
    login_as(librarian_user)

    edit_book(book)

    expect(page.current_path).to eq book_path(Book.last)
    expect(page).to have_content("O livro #{book.title} foi atualizado com sucesso.")
  end

  scenario 'with invalid input (without title)' do
    login_as(librarian_user)

    book.title = nil
    edit_book(book)

    expect(page.current_path).to eq book_path(book)
    expect(page).to have_content("Título não pode ficar em branco e Título é muito curto (mínimo: 3 caracteres)")
  end

  scenario 'with invalid input (short title)' do
    login_as(librarian_user)

    book.title = 'ab'
    edit_book(book)

    expect(page.current_path).to eq book_path(book)
    expect(page).to have_content("Título é muito curto (mínimo: 3 caracteres)")
  end

  scenario 'with invalid input (without description)' do
    login_as(librarian_user)

    book.description = nil
    edit_book(book)

    expect(page.current_path).to eq book_path(book)
    expect(page).to have_content("Descrição não pode ficar em branco e Descrição é muito curto (mínimo: 3 caracteres)")
  end

  scenario 'with invalid input (short description)' do
    login_as(librarian_user)

    book.description = 'ab'
    edit_book(book)

    expect(page.current_path).to eq book_path(book)
    expect(page).to have_content("Descrição é muito curto (mínimo: 3 caracteres)")
  end

  scenario 'with invalid input (without image_url)' do
    login_as(librarian_user)

    book.image_url = nil
    edit_book(book)

    expect(page.current_path).to eq book_path(book)
    expect(page).to have_content("URL da capa não pode ficar em branco")
  end

  scenario 'with invalid input (without page_count)' do
    login_as(librarian_user)

    book.page_count = nil
    edit_book(book)

    expect(page.current_path).to eq book_path(book)
    expect(page).to have_content("Quantidade de páginas não pode ficar em branco e Quantidade de páginas não é um número")
  end

  scenario 'with invalid input (page_count with zero value)' do
    login_as(librarian_user)

    book.page_count = 0
    edit_book(book)

    expect(page.current_path).to eq book_path(book)
    expect(page).to have_content("Quantidade de páginas deve ser maior que 0")
  end

  scenario 'with invalid input (without author)' do
    login_as(librarian_user)

    book.author = nil
    edit_book(book)

    expect(page.current_path).to eq book_path(book)
    expect(page).to have_content("Autor não pode ficar em branco e Autor é muito curto (mínimo: 3 caracteres)")
  end

  scenario 'with invalid input (short author)' do
    login_as(librarian_user)

    book.author = 'ab'
    edit_book(book)

    expect(page.current_path).to eq book_path(book)
    expect(page).to have_content("Autor é muito curto (mínimo: 3 caracteres)")
  end
end
