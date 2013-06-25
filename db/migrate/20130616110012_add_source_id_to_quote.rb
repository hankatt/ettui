class AddSourceIdToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :source_id, :integer
  end
end
