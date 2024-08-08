class AddReadabilityAuthorToQuotes < ActiveRecord::Migration[4.2]
  def change
    add_column :quotes, :readability_author, :string
  end
end
