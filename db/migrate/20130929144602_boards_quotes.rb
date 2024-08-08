class BoardsQuotes < ActiveRecord::Migration[4.2]
  def change
    create_join_table :boards, :quotes
  end
end
