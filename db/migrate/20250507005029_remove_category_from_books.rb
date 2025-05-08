class RemoveCategoryFromBooks < ActiveRecord::Migration[8.0]
  def change
    remove_column :books, :category, :string
  end
end
