class Board < ActiveRecord::Base

    acts_as_tagger
	has_and_belongs_to_many :quotes
	has_and_belongs_to_many :users, :join_table => :subscriptions

	def complex_find_by(params)
		if params[:search] && params[:source_ids]
            self.quotes.order(created_at: :desc).where("source_id IN (?) AND text LIKE ?", params[:source_ids], "%#{params[:search]}%").order(:created_at)
        elsif params[:search]
            self.quotes.order(created_at: :desc).where("text LIKE ?", "%#{params[:search]}%").order(:created_at)
        elsif params[:source_ids]
            self.quotes.order(created_at: :desc).where("source_id IN (?)", params[:source_ids]).order(:created_at)
        else
            self.quotes.order(created_at: :desc).to_a
        end
	end
end
