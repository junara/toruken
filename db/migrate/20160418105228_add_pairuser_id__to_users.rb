class AddPairuserIdToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :pairuser, index: true
  end
end
