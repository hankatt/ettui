class Board < ActiveRecord::Base

    acts_as_tagger
	has_and_belongs_to_many :quotes
	has_and_belongs_to_many :users, :join_table => :subscriptions

	def complex_find_by(params)
        if params[:search] && params[:source_ids] && params[:tag_ids]
            self.quotes.order(created_at: :desc).where("source_id IN (?) AND text LIKE ?", params[:source_ids], "%#{params[:search]}%").tagged_with(self.owned_tags.find(params[:tag_ids])).distinct
		elsif params[:search] && params[:source_ids]
            self.quotes.order(created_at: :desc).where("source_id IN (?) AND text LIKE ?", params[:source_ids], "%#{params[:search]}%")
        elsif params[:search] && params[:tag_ids]
            self.quotes.order(created_at: :desc).where("text LIKE ?", "%#{params[:search]}%").tagged_with(self.owned_tags.find(params[:tag_ids])).distinct
        elsif params[:tag_ids] && params[:source_ids]
            self.quotes.order(created_at: :desc).where("source_id IN (?)", params[:source_ids]).tagged_with(self.owned_tags.find(params[:tag_ids])).distinct
        elsif params[:tag_ids]
            self.quotes.order(created_at: :desc).tagged_with("design")
        elsif params[:search]
            self.quotes.order(created_at: :desc).where("text LIKE ?", "%#{params[:search]}%")
        elsif params[:source_ids]
            self.quotes.order(created_at: :desc).where("source_id IN (?)", params[:source_ids])
        else
            self.quotes.order(created_at: :desc).to_a
        end
	end
end
