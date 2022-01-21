require "rails_helper"

RSpec.describe "creating a book", :type => :system do
  let(:reader_user) { create(:reader) }
  let(:librarian_user) { create(:librarian) }

  let(:book) { build(:book) }

  scenario 'without permission' do
    login_as(reader_user)

    visit new_book_path

    expect(page.current_path).to eq books_path
    expect(page).to have_content("Você não está autorizado a realizar esta ação.")
  end

  scenario 'with valid inputs' do
    login_as(librarian_user)

    create_book(book)

    expect(page.current_path).to eq book_path(Book.last)
    expect(page).to have_content("O livro #{book.title} foi cadastrado com sucesso.")
  end

  scenario 'with invalid input (without title)' do
    login_as(librarian_user)

    book.title = nil
    create_book(book)

    expect(page.current_path).to eq books_path
    expect(page).to have_content("Título não pode ficar em branco e Título é muito curto (mínimo: 3 caracteres)")
  end

  scenario 'with invalid input (short title)' do
    login_as(librarian_user)

    book.title = 'ab'
    create_book(book)

    expect(page.current_path).to eq books_path
    expect(page).to have_content("Título é muito curto (mínimo: 3 caracteres)")
  end

  scenario 'with invalid input (without description)' do
    login_as(librarian_user)

    book.description = nil
    create_book(book)

    expect(page.current_path).to eq books_path
    expect(page).to have_content("Descrição não pode ficar em branco e Descrição é muito curto (mínimo: 3 caracteres)")
  end

  scenario 'with invalid input (short description)' do
    login_as(librarian_user)

    book.description = 'ab'
    create_book(book)

    expect(page.current_path).to eq books_path
    expect(page).to have_content("Descrição é muito curto (mínimo: 3 caracteres)")
  end

  scenario 'with invalid input (without image_url)' do
    login_as(librarian_user)

    book.image_url = nil
    create_book(book)

    expect(page.current_path).to eq books_path
    expect(page).to have_content("URL da capa não pode ficar em branco")
  end

  scenario 'with invalid input (without page_count)' do
    login_as(librarian_user)

    book.page_count = nil
    create_book(book)

    expect(page.current_path).to eq books_path
    expect(page).to have_content("Quantidade de páginas não pode ficar em branco e Quantidade de páginas não é um número")
  end

  scenario 'with invalid input (page_count with zero value)' do
    login_as(librarian_user)

    book.page_count = 0
    create_book(book)

    expect(page.current_path).to eq books_path
    expect(page).to have_content("Quantidade de páginas deve ser maior que 0")
  end

  scenario 'with invalid input (without author)' do
    login_as(librarian_user)

    book.author = nil
    create_book(book)

    expect(page.current_path).to eq books_path
    expect(page).to have_content("Autor não pode ficar em branco e Autor é muito curto (mínimo: 3 caracteres)")
  end

  scenario 'with invalid input (short author)' do
    login_as(librarian_user)

    book.author = 'ab'
    create_book(book)

    expect(page.current_path).to eq books_path
    expect(page).to have_content("Autor é muito curto (mínimo: 3 caracteres)")
  end
end
