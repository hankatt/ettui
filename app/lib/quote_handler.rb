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
    readability_response = ReadabilityResponse.new(quote[:url])

    # Complete 'quote' hash for creation
  	quote[:source_id] = source.id
    quote[:readability_title] = readability_response.title
    quote[:readability_author] = readability_response.author

    # Create Quote object
    @quote = Quote.new(quote)

    # Return @quote
    @quote
  end
end
