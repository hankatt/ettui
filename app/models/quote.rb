class Quote < ActiveRecord::Base
	attr_accessible :text, :user_id, :source
	belongs_to :user
end
