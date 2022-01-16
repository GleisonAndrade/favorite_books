class AddStatusToBook < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :status, :string, default: 'active'
  end
end
