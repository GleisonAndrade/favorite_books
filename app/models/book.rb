class Book < ApplicationRecord
  extend Enumerize
  paginates_per 5

  has_many :users_books, dependent: :destroy
  has_many :users, through: :users_books
  accepts_nested_attributes_for :users_books

  enumerize :status, in: %i[active inactive], scope: true, predicates: true, default: :active,
                     i18n_scope: ['activerecord.enumerize.book.status']

  validates :title, :description, :image_url, :page_count, :author, presence: true
  validates :title, :description, :author, length: { minimum: 3 }
  validates :page_count, numericality: { only_integer: true, greater_than: 0 }

  scope :actives, -> { where(status: :active) }
  scope :inactives, -> { where(status: :inactive) }
  scope :contains_text, lambda { |text|
                          where('books.title ilike ? OR books.description ilike ?', "%#{text}%", "%#{text}%")
                        }
  scope :with_author, ->(author) { where('books.author ilike ?', "%#{author}%") }
  scope :order_by, lambda { |criteria|
    case criteria
    when 'OrderByCreatedAtDesc'
      order(created_at: :desc)
    when 'OrderByCreatedAtAsc'
      order(created_at: :asc)
    when 'OrderByTitleAsc'
      order(title: :asc)
    when 'OrderByTitleDesc'
      order(title: :desc)
    end
  }

  def favorite(user)
    return unless check_user_reader(user)
    return remove_favorite(user) if favorite?(user)

    add_favorite(user)
  end

  def favorite?(user)
    user.profile.reader? && users_books.with_user(user).actives.favorites.any?
  end

  def follow?(user)
    user.profile.reader? && users_books.with_user(user).actives.any?
  end

  def remove(user)
    return unless check_nonuser_reader(user)

    return unless check_active_book

    self.status = :inactive
    save!
  rescue StandardError
    errors.add(:base, 'Não foi possível excluír o livro')
    false
  end

  def create(user, book_params)
    begin
      if check_nonuser_reader(user)
        assign_attributes(book_params)
        return save!
      end
    rescue StandardError
      errors.add(:base, 'Não foi possível cadastrar o livro')
      return false
    end

    false
  end

  def edit(user, book_params)
    if check_nonuser_reader(user) && status.active?
      assign_attributes(book_params)
      save!
    else
      errors.add(:base, 'O livro não pode ser atualizado, pois já foi removido')
      false
    end
  rescue StandardError
    errors.add(:base, 'Não foi possível editar o livro')
    false
  end

  def self.favorite_books(user)
    Book.joins(:users_books).where(users_books: { favorite: true,
                                                  user_id: user.id }).where.not(users_books: { status: :excluded })
  end

  private

  # will only be used when the follow books flow is created
  def follow(user)
    return unless check_user_reader(user)

    if follow?(user)
      errors.add(:base, 'Você já está seguindo este livro')
    else
      create_user_book(user, favorite: false)
    end
  end

  def check_user_reader(user)
    unless user.profile.reader?
      errors.add(:base, 'Apenas usuários leitores podem realizar essa ação')
      return false
    end

    true
  end

  def check_nonuser_reader(user)
    if user.profile.reader?
      errors.add(:base, 'Apenas usuários administradores e bibliotecários podem realizar essa ação')
      return false
    end

    true
  end

  def add_favorite(user)
    errors.add(:base, 'Não foi possível adicionar o livro aos favoritos') unless create_user_book(user, favorite: true)
  rescue StandardError
    errors.add(:base, 'Não foi possível adicionar o livro aos favoritos')
    false
  end

  def remove_favorite(user)
    user_book = users_books.with_user(user).actives.favorites.first
    user_book.favorite = false
    user_book.status = :excluded
    user_book.save!
  rescue StandardError
    errors.add(:base, 'Não foi possível remover o livros dos favoritos')
    false
  end

  def create_user_book(user, favorite: false)
    if user.valid? && valid?
      user_book = UserBook.find_or_initialize_by(user: user, book: self)

      user_book.status = :added
      user_book.pages_read = 0
      user_book.favorite = favorite
      user_book.created_at = Time.zone.now if user_book.present?

      return user_book.save!
    end
    false
  end

  def check_active_book
    unless status.active?
      errors.add(:base, 'O livro já foi removido')
      return false
    end

    true
  end
end
