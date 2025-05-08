class CreateReads < ActiveRecord::Migration[8.0]
  def change
    create_table :reads do |t|
      t.references :user, foreign_key: true
      t.references :book, foreign_key: true

      t.timestamps
    end
    add_index :reads, [:user_id, :book_id], unique: true
  end
end