class AddItemTagToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :item_tag, :text
  end
end
