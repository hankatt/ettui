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
            self.quotes.order(created_at: :desc).tagged_with(self.owned_tags.find(params[:tag_ids]))
        elsif params[:search]
            self.quotes.order(created_at: :desc).where("text LIKE ?", "%#{params[:search]}%")
        elsif params[:source_ids]
            self.quotes.order(created_at: :desc).where("source_id IN (?)", params[:source_ids])
        else
            self.quotes.order(created_at: :desc)
        end
	end

    def unread(user_last_active_at)
        self.quotes.order(created_at: :desc).where("created_at > ?", user_last_active_at).to_a
    end

    def owns_tag(tag_name)
        if owned_tags.empty?
            return false
        else
            owned_tags.any? do |tag|
                tag.name == tag_name
            end
        end
    end

    def tag_count(tag)
        owned_taggings.where(:tag_id => tag.id).count
    end
end
