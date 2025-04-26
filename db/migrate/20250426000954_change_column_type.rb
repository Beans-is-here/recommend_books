class ChangeColumnType < ActiveRecord::Migration[8.0]
  def change
    change_column_default :users, :created_at, Time.current
  end
end
