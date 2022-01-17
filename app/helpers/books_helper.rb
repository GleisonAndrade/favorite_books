module BooksHelper
  def book_status_badge(book)
    if book.active?
      "<span class='badge bg-success'>#{book.status_text}</span>".html_safe
    elsif book.inactive?
      "<span class='badge bg-danger'>#{book.status_text}</span>".html_safe
    end
  end

  def options_for_select_books_order_by
    [
      ["Recentemente adicionado", "OrderByCreatedAtDesc"],
      ["Mais antigo","OrderByCreatedAtAsc"],
      ["Título A-Z","OrderByTitleAsc"],
      ["Título Z-A","OrderByTitleDesc"]
    ]
  end
end
