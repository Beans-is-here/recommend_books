class CreateTagMaps < ActiveRecord::Migration[8.0]
  def change
    create_table :tag_maps do |t|
      t.references :book, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
