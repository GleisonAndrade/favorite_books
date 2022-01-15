class Book < ApplicationRecord
  has_many :users_books, dependent: :destroy
  has_many :users, through: :users_books

  accepts_nested_attributes_for :users_books

  validates :title, :description, :image_url, :page_count, :author, presence: true
  validates :title, :description, :author, length: { minimum: 3 }
  validates :page_count, numericality: { only_integer: true, greater_than: 0 }

  def favorite(user)
    if check_reader?(user)
      if favorite?(user)
        remove_favorite(user)
      else
        add_favorite(user)
      end
    end
  end

  def favorite?(user)
    user.profile.reader? && self.users_books.where(user: user).where.not(status: :excluded).where(favorite: true).any?
  end

  def follow?(user)
    user.profile.reader? && self.users_books.where(user: user).where.not(status: :excluded).any?
  end

  private

    # will only be used when the follow books flow is created
    def follow(user)
      if check_reader?(user)
        if follow?(user)
          self.errors.add(:base, "Você já está seguindo este livro")
        else
          create_user_book(user)
        end
      end
    end

    def check_reader?(user)
      unless user.profile.reader?
        self.errors.add(:base, "Apenas usuários leitores podem realizar essa ação")
        return false
      end

      true
    end
    
    def add_favorite(user)
      begin
        create_user_book(user, true)
      rescue
        self.errors.add(:base, "Não foi possível adicionar o livro aos favoritos")
      end
    end
    
    def remove_favorite(user)
      begin
        user_book = self.users_books.where(user: user).where.not(status: :excluded).where(favorite: true).first
        user_book.favorite = false
        user_book.status = :excluded
        user_book.save!
      rescue
        self.errors.add(:base, "Não foi possível remover o livros dos favoritos")
      end
    end

    def create_user_book(user, favorite=false)
      user_book = UserBook.find_or_initialize_by(user: user, book: self)

      user_book.status = :added
      user_book.pages_read = 0
      user_book.favorite = favorite
      user_book.created_at = Time.zone.now if user_book.present?

      user_book.save!
    end

end
