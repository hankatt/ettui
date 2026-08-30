require "json"

class QuoteHandler
  def self.create_for_user(params, user_id)

  	# Initiate 'quote' hash with known data
  	quote = {}
  	quote[:user_id] = user_id
    quote[:text] = CGI.unescape(params[:text]) if params[:text].present?

    if params[:source] == "non-web"
      source = Source.find_or_create_by!(hostname: "From an app")
    else
      quote[:url] = CGI.unescape(params[:url])
      hostname   = HostnameParser.parse(quote[:url])
      favicon    = CGI.unescape(params[:favicon]).split("?").first
      domTitle   = CGI.unescape(params[:dom_title])

      source = Source.find_by(hostname: hostname)
      unless source
        source = Source.new(hostname: hostname)
        source.favicon = source.validate_favicon(favicon)
        source.save
      end
      quote[:readability_title] = domTitle.empty? ? extract_title(quote[:url]) : domTitle
    end

  	quote[:source_id] = source.id

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
