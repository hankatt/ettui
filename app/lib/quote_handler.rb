require "json"

class QuoteHandler
  def self.create_for_user(params, user_id)

  	# Initiate 'quote' hash with known data
  	quote = {}
  	quote[:user_id] = user_id
  	quote[:text] = CGI.unescape(params[:text])
  	quote[:url] = CGI.unescape(params[:url])

    # Set up metadata for 'quote' hash
    hostname = HostnameParser.parse(quote[:url])
    favicon = CGI.unescape(params[:favicon]).split("?").first
    domTitle= CGI.unescape(params[:dom_title])

    source = Source.find_by(hostname: hostname) || Source.create(hostname: hostname, favicon: favicon)

    # Complete 'quote' hash for creation
  	quote[:source_id] = source.id
    if domTitle.empty?
      # Only query Claude if we dont have anything
      quote[:readability_title] = extract_title(quote[:url])
    else
      quote[:readability_title] = domTitle
    end

    # Create Quote object
    @quote = Quote.new(quote)

    # Return @quote
    @quote
  end

  private

  def self.extract_title(url)
    html = RestClient.get(url).body

    response = RestClient.post(
      "https://api.anthropic.com/v1/messages",
      {
        model: "claude-haiku-4-5-20251001",
        max_tokens: 100,
        messages: [{ role: "user", content: "Return only the article title from this HTML, nothing else:\n\n#{html[0, 5000]}" }]
      }.to_json,
      {
        "x-api-key"         => ENV["ANTHROPIC_API_KEY"],
        "anthropic-version" => "2023-06-01",
        "content-type"      => "application/json"
      }
    )

    JSON.parse(response.body).dig("content", 0, "text")&.strip
  rescue StandardError
    nil
  end
end
