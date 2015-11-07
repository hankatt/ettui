class HostnameParser
  def self.parse(url)
    if URI.parse(url).host.nil?
      url = URI.unescape(url)
    end

    URI.parse(url).host.sub(/\Awww\./, '')
  end
end
