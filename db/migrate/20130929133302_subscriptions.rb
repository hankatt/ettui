class Subscriptions < ActiveRecord::Migration
	def change
		create_table :subscriptions, :id => false do |t|
			t.belongs_to :board
			t.belongs_to :user
		end
	end
end
