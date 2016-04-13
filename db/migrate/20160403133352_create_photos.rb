class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :item_name
      t.references :user, index: true, foreign_key: true
      t.text :content
      t.string :item_name
      t.float :item_value
      t.date :item_date
      t.time :item_time
      
      t.timestamps null: false
      t.index [:user_id, :created_at]
    end
  end
end
