class AddNewUserToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :new_user, :boolean
  end
end
