module BooksHelper
  def book_status_badge(book)
    if book.active?
      "<span class='badge bg-success'>#{book.status_text}</span>".html_safe
    elsif book.inactive?
      "<span class='badge bg-danger'>#{book.status_text}</span>".html_safe
    end
  end
end
