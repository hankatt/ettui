class AddUrlToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :url, :string
  end
end
