class User < ApplicationRecord
  extend Enumerize

  has_many :users_books, dependent: :destroy
  has_many :books, through: :users_books  

  enumerize :profile, in: [:admin, :librarian, :reader], scope: true, predicates: true, default: :reader

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :name, :profile, presence: true
  validates :name, length: { minimum: 3 }
  validates_inclusion_of :profile, in: User.profile.values

end
