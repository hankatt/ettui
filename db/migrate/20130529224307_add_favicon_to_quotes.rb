class AddFaviconToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :favicon, :string
  end
end
