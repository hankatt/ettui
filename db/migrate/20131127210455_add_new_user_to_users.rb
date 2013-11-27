class AddNewUserToUsers < ActiveRecord::Migration
  def change
    add_column :users, :new_user, :boolean
  end
end
