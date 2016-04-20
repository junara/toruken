class AddPairuserIdToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :pairuser, index: true, foreign_key: true
  end
end
