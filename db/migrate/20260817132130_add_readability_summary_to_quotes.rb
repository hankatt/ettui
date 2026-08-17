class AddReadabilitySummaryToQuotes < ActiveRecord::Migration[6.0]
  def change
    add_column :quotes, :readability_summary, :text
  end
end
