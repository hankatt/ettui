class Board < ActiveRecord::Base

  has_and_belongs_to_many :quotes
  has_and_belongs_to_many :users, :join_table => :subscriptions
  has_many :tags, through: :quotes
  has_many :sources, through: :quotes

  def unread(user_last_active_at)
      self.quotes.order(created_at: :desc).where("created_at > ?", user_last_active_at).to_a
  end

  def tag_count tag
    tags.where(name: tag.name).count
  end

  def unique_tags
      tags.uniq
  end

  def source_count source
    sources.where(id: source.id).count
  end

  def has_subscribers?
      users.count > 1
  end
end
