class ParserResponse
  attr_reader :title, :author

  def initialize(url)
    parsed_response = ContentParser.parse_url(url)
    @title = parsed_response["title"]
    @author = parsed_response["author"]
  end

  def author
    @author unless author_has_long_name? || author_has_many_names?
  end

  private
  def author_has_long_name?
    @author.length > 34 if @author
  end

  def author_has_many_names?
    @author.scan(/\w+/).size > 4 if @author
  end
end
