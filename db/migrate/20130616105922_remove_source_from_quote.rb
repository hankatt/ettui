class RemoveSourceFromQuote < ActiveRecord::Migration
  def up
    remove_column :quotes, :source
      end

  def down
    add_column :quotes, :source, :string
  end
end
