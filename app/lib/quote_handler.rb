class QuoteHandler
  def self.create_for_user(params, user_id)

  	# Initiate 'quote' hash with known data
  	quote = {}
  	quote[:user_id] = user_id
  	quote[:text] = CGI.unescape(params[:text])
  	quote[:url] = CGI.unescape(params[:url])

    # Set up metadata for 'quote' hash
    hostname = HostnameParser.parse(quote[:url])
    favicon = CGI.unescape(params[:favicon])
    domTitle= CGI.unescape(params[:dom_title])

    source = Source.find_by(hostname: hostname) || Source.create(hostname: hostname, favicon: favicon)
    # content_parser_response = ParserResponse.new(quote[:url])
    # ParserResponse RELIES ON READABILITY CONTENT PARSER AND IS NO LONGER AVAILABLE

    # Complete 'quote' hash for creation
  	quote[:source_id] = source.id
    quote[:readability_title] = domTitle # Previously 'content_parser_response'

    # Create Quote object
    @quote = Quote.new(quote)

    # Return @quote
    @quote
  end
end
