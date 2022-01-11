class User < ApplicationRecord
  extend Enumerize

  enumerize :profile, in: [:admin, :librarian, :read], scope: true, predicates: true, default: :read

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :name, :profile, presence: true
  validates :name, length: { minimum: 3 }
  validates_inclusion_of :profile, in: User.profile.values

end
