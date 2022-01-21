# https://thoughtbot.com/blog/automatically-wait-for-ajax-with-capybara
module CapybaraHelpers
  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
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
end
