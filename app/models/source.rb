class Source < ActiveRecord::Base
	attr_accessible :favicon, :hostname
	has_many :quotes
end
