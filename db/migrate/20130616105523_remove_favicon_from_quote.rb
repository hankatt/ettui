class RemoveFaviconFromQuote < ActiveRecord::Migration
  def up
    remove_column :quotes, :favicon
      end

  def down
    add_column :quotes, :favicon, :string
  end
end
