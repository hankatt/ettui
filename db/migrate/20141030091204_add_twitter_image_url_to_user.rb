class AddTwitterImageUrlToUser < ActiveRecord::Migration
  def change
    add_column :users, :twitter_image_url, :string
  end
end
