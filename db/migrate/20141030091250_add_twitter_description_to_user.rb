class AddTwitterDescriptionToUser < ActiveRecord::Migration
  def change
    add_column :users, :twitter_description, :string
  end
end
