class ContentParser

  # URL to Readability's Parser API
  PARSER_URI = URI('https://mercury.postlight.com/parser')
  PARSER_TOKEN = 'YuMAgDBR7CoaYbSqbVQyj2xMWnnuTYqBzHjsluSv'

  def self.parse_url(url)
    # URL to parse with the Parser API
    url = URI.unescape(url)

    # Format params to web form format
    PARSER_URI.query = URI.encode_www_form({:url => url, "x-api-token" => PARSER_TOKEN })

    # Readability Parser response
    response = Net::HTTP.get_response(PARSER_URI)
    parsed = ActiveSupport::JSON.decode(response.body)

    # Returns parsed
    parsed
  end
end

=begin
class ReadabilityParser

  # URL to Readability's Parser API
  READABILITY_URI = URI('http://www.readability.com/api/content/v1/parser')
  READABILITY_TOKEN = '34831792edfc0cf8e42b3e82086f00970a53407b'

  def self.parse_url(url)
    # URL to parse with the Parser API
    url = URI.unescape(url)

    # Format params to web form format
    READABILITY_URI.query = URI.encode_www_form({:url => url, :token => READABILITY_TOKEN })

    # Readability Parser response
    response = Net::HTTP.get_response(READABILITY_URI)
    parsed = ActiveSupport::JSON.decode(response.body)

    # Returns parsed
    parsed
  end
end
=end
