class Quote < ActiveRecord::Base

  scope :since, ->(date) { where("created_at > ?", date) }
  
  has_and_belongs_to_many :boards
  belongs_to :source
  has_and_belongs_to_many :tags

  delegate :favicon, to: :source

  def self.in_board(board)
    board.quotes
  end

  def self.filter_by_source_ids(source_ids)
    if source_ids.empty?
      all
    else
      where(source_id: source_ids)
    end
  end

  def self.new_quote_count(user)
    where("created_at > ?", user.last_active_at).count
  end

  def self.filter_by_text(filter_text)
    if filter_text.blank?
      all
    else
      where("text LIKE ?", "%#{filter_text}%")
    end
  end

  def has_tag(tag_name)
    tags.map(&:name).include?(tag_name)
  end

  def title
    if readability_title
      readability_title
    else
      url
    end
  end

  def unique_tags
    tags.uniq
  end

  def new_since_last(user)
    return false unless user
    
    created_at > user.last_active_at
  end

  def classes_for(user)
    if new_since_last(user)
      default_classes << " unread"
    else
      default_classes
    end
  end

  def excerpt

  end

  def default_classes
    "c-quote q-#{id}"
  end

  def highlight search_query
    if search_query.nil?
      query = ""
    end

    if search_query
      query = search_query
    end
    QuoteHighlighter.hilight(self, query)
  end

  def font_size
    case
    when text.length < 140
      "big"
    when text.length > 280
      "small"
    else
      ""
    end
  end

  def source_date
    "#{created_at.day} #{created_at.strftime("%b")}"
  end

end
