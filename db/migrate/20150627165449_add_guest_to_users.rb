class AddGuestToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :guest, :boolean
  end
end
