class ChangeColumnType2 < ActiveRecord::Migration[8.0]
  def change
    change_column_default :users, :updated_at, Time.current
  end
end
