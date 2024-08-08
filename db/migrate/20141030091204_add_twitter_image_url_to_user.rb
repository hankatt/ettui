class AddTwitterImageUrlToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :twitter_image_url, :string
  end
end
