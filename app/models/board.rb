class Board < ActiveRecord::Base
	has_and_belongs_to_many :quotes
	has_and_belongs_to_many :users, :join_table => :subscriptions
end
