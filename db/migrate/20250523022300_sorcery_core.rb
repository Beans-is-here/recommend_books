class SorceryCore < ActiveRecord::Migration[8.0]
  def change
      change_column :users, :email, :string, null: false
      add_column :users,  :salt, :string
  end
end
