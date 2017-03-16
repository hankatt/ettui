class QuoteHandler
  def self.create_for_user(params, user_id)

  	# Initiate 'quote' hash with known data
  	quote = {}
  	quote[:user_id] = user_id
  	quote[:text] = URI.unescape(params[:text])
  	quote[:url] = URI.unescape(params[:url])

    # Set up metadata for 'quote' hash
    hostname = HostnameParser.parse(quote[:url])
    favicon = URI.unescape(params[:favicon])

    source = Source.find_by(hostname: hostname) || Source.create(hostname: hostname, favicon: favicon)
    content_parser_response = ParserResponse.new(quote[:url])

    # Complete 'quote' hash for creation
  	quote[:source_id] = source.id
    quote[:readability_title] = content_parser_response.title

    # Create Quote object
    @quote = Quote.new(quote)

    # Return @quote
    @quote
  end
end
