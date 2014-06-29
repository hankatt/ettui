class Board < ActiveRecord::Base

    acts_as_tagger
	has_and_belongs_to_many :quotes
	has_and_belongs_to_many :users, :join_table => :subscriptions

	def complex_find_by(params)
		if params[:search] && params[:source_ids]
            self.quotes.where("source_id IN (?) AND text LIKE ?", params[:source_ids], "%#{params[:search]}%")
        elsif params[:search]
            self.quotes.where("text LIKE ?", "%#{params[:search]}%")
        elsif params[:source_ids]
            self.quotes.where("source_id IN (?)", params[:source_ids])
        else
            self.quotes.to_a
        end
	end
end
