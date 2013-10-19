class BoardsQuotes < ActiveRecord::Migration
	def change
		create_join_table :boards, :quotes
	end
end
