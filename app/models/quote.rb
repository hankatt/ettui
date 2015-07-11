class Quote < ActiveRecord::Base

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

  def self.filter_by_text(filter_text)
    if filter_text.length < 1
      all
    else
      where("text LIKE ?", "%#{filter_text}%")
    end
  end

  def has_tag(tag_name)
    if tags.empty?
      return false
    else
      tags.any? do |tag|
        tag.name == tag_name
      end
    end
  end

  def update_readability_data
    # URL to Readability's Parser API
      uri = URI('http://www.readability.com/api/content/v1/parser')
      token = '34831792edfc0cf8e42b3e82086f00970a53407b'

        # Format params for web encoding
        uri.query = URI.encode_www_form({:url => url, :token => token })

        # Readability Parser response
        response = Net::HTTP.get_response(uri)
        parsed = ActiveSupport::JSON.decode(response.body)

        # Attributes to update
        title = parsed["title"]
        author = parsed["author"]

        # Validate that it is just the author
        # Assume most names won't use more than 4 names tops
        # Assume most names won't be that long, 34 chars tops
        if author.nil? || author.scan(/\w+/).size > 4 || author.length > 34
          author = nil
        end

        # Update attributes
        update(
          :readability_title => title,
          :readability_author => author
        )
  end

  def truncated_readability_title
    readability_title.truncate(64)
  end

  def unique_tags
    tags.uniq
  end

  def classes_for(user)
    if new_since_last(user)
      default_classes << " unread"
    else
      default_classes
    end
  end

  def default_classes
    "c-quote q-#{id}"
  end

  def highlight query
    if text.length > 280
      em_start_index = em_end_index = em_word_count = 0
      em_final_word_count = 4 # Number of words to emphasize
      text.length.times do |i|
        if text.at(i).eql?(" ")
          em_word_count = em_word_count + 1
          if em_word_count.eql?(em_final_word_count)
            em_end_index = i
            break
          end
        end
      end
      text.insert(em_end_index, "</em>")
      text.insert(em_start_index, "<em>")
    end

    if query.eql?("") || query.nil?
      text
    else
      text.gsub(/#{query}/, "<mark>#{query}</mark>")
    end
  end

  def new_since_last(user)
    #created_at > user.last_active_at
    false
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
