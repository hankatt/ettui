class TagHandler
  def self.find_or_initialize(params)
    tag = Tag.find_or_initialize_by(name: URI.unescape(params).downcase);

    # Update tag status for Tag List rendering purposes
    if tag.new_record? && tag.valid?
      tag.save
      tag.is_new = true
    else
      tag.is_existing = true
    end

    # Return tag
    tag

  end
end