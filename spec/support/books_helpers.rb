module BooksHelpers

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

  def have_book(book, with_title:  true, with_status:  false, with_created_at: true, with_page_count: false, with_author: true)
    # puts "with_title: #{with_title}, with_status: #{with_status}, with_created_at: #{with_created_at}, with_page_count: #{with_page_count}, with_author: #{with_author}"

    if book.present?      
      if with_author
        expect(page).to have_content(book.author)
      end

      if with_page_count
        expect(page).to have_content(book.page_count)
      end
      
      if with_title
        expect(page).to have_content(book.title)
      end
      
      if with_status
        expect(page).to have_content('Status')
        expect(page).to have_content(book.status_text)
      end

      if with_created_at
        expect(page).to have_content("#{I18n.l book.created_at, format: "%d de %B"}")
        expect(page).to have_content("#{ I18n.l book.created_at, format: "%H:%M" }")
      end
    end
  end

  def have_not_book(book, with_title: true, with_status: false, with_created_at: true, with_page_count: false, with_author: true)
    # puts "with_title: #{with_title}, with_status: #{with_status}, with_created_at: #{with_created_at}, with_page_count: #{with_page_count}, with_author: #{with_author}"
    if book.present?
      if with_author
        expect(page).to_not have_content(book.author)
      end

      if with_page_count
        expect(page).to_not have_content(book.page_count)
      end
      
      if with_title
        expect(page).to_not have_content(book.title)
      end
      
      if with_status
        expect(page).to_not have_content('Status')
        expect(page).to_not have_content(book.status_text)
      end

      if with_created_at
        expect(page).to_not have_content("#{I18n.l book.created_at, format: "%d de %B"}")
        expect(page).to_not have_content("#{ I18n.l book.created_at, format: "%H:%M" }")
      end
    end
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

  def create_book(book)
    visit books_path
    click_on 'Novo Livro'

    expect(page).to have_content('Novo Livro')

    fill_in 'book_title', with: book.title
    fill_in 'book_description', with: book.description
    fill_in 'book_image_url', with: book.image_url
    fill_in 'book_page_count', with: book.page_count
    fill_in 'book_author', with: book.author

    click_button 'Criar Livro'
    # find('#button_submit_form').click
  end

  def edit_book(book)
    visit books_path

    find(:xpath, "//a[@href='/books/#{book.id}/edit']").click

    expect(page).to have_content('Editar Livro')

    fill_in 'book_title', with: book.title
    fill_in 'book_description', with: book.description
    fill_in 'book_image_url', with: book.image_url
    fill_in 'book_page_count', with: book.page_count
    fill_in 'book_author', with: book.author

    click_button 'Atualizar Livro'
  end
end
