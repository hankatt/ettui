module SourcesHelper
  def getHostname(url)
    URI.parse(url).host.sub(/\Awww\./, '')
  end
end
