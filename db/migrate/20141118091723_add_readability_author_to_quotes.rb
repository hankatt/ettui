class AddReadabilityAuthorToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :readability_author, :string
  end
end
