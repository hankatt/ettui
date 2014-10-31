class AddReadabilityTitleToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :readability_title, :string
  end
end
