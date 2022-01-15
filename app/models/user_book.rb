class UserBook < ApplicationRecord
  extend Enumerize

  belongs_to :user
  belongs_to :book

  enumerize :status, in: [:added, :read, :finished, :excluded], scope: true, predicates: true, default: :added

  validates :user_id, :book_id, presence: true
  validates :pages_read, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :favorite, exclusion: [nil]
end
