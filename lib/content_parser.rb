class ContentParser

  # URL to Readability's Parser API
  PARSER_URI = URI('https://mercury.postlight.com/parser')
  PARSER_TOKEN = 'YuMAgDBR7CoaYbSqbVQyj2xMWnnuTYqBzHjsluSv'

  def self.parse_url(url)
    # URL to parse with the Parser API
    url = URI.unescape(url)

    # Format params to web form format
    PARSER_URI.query = URI.encode_www_form(:url => url)

    request = Net::HTTP::Get.new(PARSER_URI)
    request["X-Api-Key"] = PARSER_TOKEN

    req_options = {
      use_ssl: PARSER_URI.scheme == "https",
    }

    res = Net::HTTP.start(PARSER_URI.hostname, PARSER_URI.port, req_options) do |http|
      http.request(request)
    end

    parsed = ActiveSupport::JSON.decode(res.body)

    # Returns parsed
    parsed
  end
end
