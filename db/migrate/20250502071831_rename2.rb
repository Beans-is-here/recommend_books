class Rename2 < ActiveRecord::Migration[8.0]
  def change
    rename_table :has_reads, :hasreads
  end
end
