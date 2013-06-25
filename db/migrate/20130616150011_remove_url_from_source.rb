class RemoveUrlFromSource < ActiveRecord::Migration
  def up
    remove_column :sources, :url
      end

  def down
    add_column :sources, :url, :string
  end
end
