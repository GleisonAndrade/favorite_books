class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :title
      t.text :description
      t.string :image_url
      t.integer :page_count
      t.string :author

      t.timestamps
    end
  end
end
