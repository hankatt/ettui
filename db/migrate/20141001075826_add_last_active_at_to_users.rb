class AddLastActiveAtToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :last_active_at, :datetime
  end
end
