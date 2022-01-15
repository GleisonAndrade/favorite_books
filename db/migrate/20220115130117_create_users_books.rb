class CreateUsersBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :users_books do |t|
      t.belongs_to :user
      t.belongs_to :book
      t.boolean :favorite, default: false
      t.string :status, default: 'added'
      t.integer :pages_read, default: 0

      t.timestamps
    end
  end
end
