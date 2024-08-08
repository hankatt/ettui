class AddReadabilityTitleToQuotes < ActiveRecord::Migration[4.2]
  def change
    add_column :quotes, :readability_title, :string
  end
end
