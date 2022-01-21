class Book < ApplicationRecord
  extend Enumerize
  paginates_per 5

  has_many :users_books, dependent: :destroy
  has_many :users, through: :users_books
  accepts_nested_attributes_for :users_books

  enumerize :status, in: [:active, :inactive], scope: true, predicates: true, default: :active, i18n_scope: ["activerecord.enumerize.book.status"]


  validates :title, :description, :image_url, :page_count, :author, presence: true
  validates :title, :description, :author, length: { minimum: 3 }
  validates :page_count, numericality: { only_integer: true, greater_than: 0 }

  scope :actives, -> { where(status: :active) }
  scope :inactives, -> { where(status: :inactive) }
  scope :contains_text, -> (text) { where("books.title ilike ? OR books.description ilike ?", "%" + text + "%",  "%" + text + "%") }
  scope :with_author, -> (author) { where("books.author ilike ?", "%" + author + "%") }
  scope :order_by, -> (criteria) do
    if criteria == 'OrderByCreatedAtDesc'
      order(created_at: :desc)
    elsif criteria == 'OrderByCreatedAtAsc'
      order(created_at: :asc)
    elsif criteria == 'OrderByTitleAsc'
      order(title: :asc)
    elsif criteria == 'OrderByTitleDesc'
      order(title: :desc)
    end
  end

  def favorite(user)
    if is_reader?(user)
      if favorite?(user)
        remove_favorite(user)
      else
        add_favorite(user)
      end
    end
  end

  def favorite?(user)
    user.profile.reader? && self.users_books.with_user(user).actives.favorites.any?
  end

  def follow?(user)
    user.profile.reader? && self.users_books.with_user(user).actives.any?
  end

  def remove(user)
    begin
      if is_not_reader?(user) && self.status.active?
        self.status = :inactive
        return self.save!
      else
        self.errors.add(:base, "O livro já foi removido")
        return false
      end
    rescue
      self.errors.add(:base, "Não foi possível excluír o livro")
      return false
    end
  end

  def edit(user, book_params)
    begin
      if is_not_reader?(user) && self.status.active?
        self.assign_attributes(book_params)
          self.save!
        else
          self.errors.add(:base, "O livro não pode ser atualizado, pois já foi removido")
          return false
        end
      rescue
        self.errors.add(:base, "Não foi possível editar o livro")
        return false
      end
  end

  def self.favorite_books(user)
    Book.joins(:users_books).where(users_books: { favorite: true, user_id: user.id }).where.not(users_books: { status: :excluded })
  end

  private

    # will only be used when the follow books flow is created
    def follow(user)
      if is_reader?(user)
        if follow?(user)
          self.errors.add(:base, "Você já está seguindo este livro")
        else
          create_user_book(user)
        end
      end
    end

    def is_reader?(user)
      unless user.profile.reader?
        self.errors.add(:base, "Apenas usuários leitores podem realizar essa ação")
        return false
      end

      true
    end

    def is_not_reader?(user)
      if user.profile.reader?
        self.errors.add(:base, "Apenas usuários administradores e bibliotecários podem realizar essa ação")
        return false
      end

      true
    end
    
    def add_favorite(user)
      begin
        unless create_user_book(user, true)
          self.errors.add(:base, "Não foi possível adicionar o livro aos favoritos")
        end
      rescue
        self.errors.add(:base, "Não foi possível adicionar o livro aos favoritos")
        return false
      end
    end
    
    def remove_favorite(user)
      begin
        user_book = self.users_books.with_user(user).actives.favorites.first
        user_book.favorite = false
        user_book.status = :excluded
        user_book.save!
      rescue
        self.errors.add(:base, "Não foi possível remover o livros dos favoritos")
        return false
      end
    end

    def create_user_book(user, favorite=false)
      if user.valid? && self.valid?
        user_book = UserBook.find_or_initialize_by(user: user, book: self)

        user_book.status = :added
        user_book.pages_read = 0
        user_book.favorite = favorite
        user_book.created_at = Time.zone.now if user_book.present?

        return user_book.save!
      end
      false
    end

end
