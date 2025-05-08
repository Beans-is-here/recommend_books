class Rename < ActiveRecord::Migration[8.0]
  def change
    rename_table :reads, :has_reads
  end
end
