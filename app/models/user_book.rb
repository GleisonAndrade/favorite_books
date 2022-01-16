class UserBook < ApplicationRecord
  extend Enumerize

  belongs_to :user
  belongs_to :book

  enumerize :status, in: [:added, :read, :finished, :excluded], scope: true, predicates: true, default: :added, i18n_scope: ["activerecord.enumerize.user_book.status"]

  validates :user_id, :book_id, presence: true
  validates :pages_read, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :favorite, exclusion: [nil]

  scope :favorites, -> { where(favorite: true) }
  scope :actives, -> {where.not(status: :excluded) }
  scope :with_user, -> (user) { where(user: user) }
  scope :with_book, -> (book) { where(book: book) }
end
