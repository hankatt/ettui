require "nokogiri"
require "rest-client"
require "uri"

class Source < ActiveRecord::Base
  has_many :quotes

  BROWSER_USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36".freeze

  FAVICON_SELECTORS = [
    'link[rel="icon"][sizes="32x32"]',
    'link[rel="icon"][sizes="16x16"]',
    'link[rel="shortcut icon"]',
    'link[rel="icon"]',
    'link[rel="apple-touch-icon"]',
    'link[rel="apple-touch-icon-precomposed"]'
  ].freeze

  def count_for board
    board.source_count self
  end

  def refresh_favicon!
    return if hostname == "From an app"
    update!(favicon: detect_favicon || probe_root_favicon || google_favicon_fallback)
  end

  private

  def detect_favicon
    %w[https http].each do |scheme|
      base_url = "#{scheme}://#{hostname}/"
      html = fetch(base_url) or next
      doc = Nokogiri::HTML(html)
      FAVICON_SELECTORS.each do |selector|
        el = doc.at_css(selector)
        href = el && el["href"]
        next if href.nil? || href.strip.empty?
        begin
          return URI.join(base_url, href).to_s
        rescue URI::InvalidURIError
          next
        end
      end
    end
    nil
  end

  def fetch(url)
    RestClient::Request.execute(
      method: :get,
      url: url,
      timeout: 8,
      open_timeout: 4,
      headers: { user_agent: BROWSER_USER_AGENT, accept: "text/html,application/xhtml+xml,*/*" }
    ).body
  rescue => e
    Rails.logger.warn "Source#refresh_favicon fetch failed for #{url}: #{e.class}: #{e.message}"
    nil
  end

  def probe_root_favicon
    %w[https http].each do |scheme|
      url = "#{scheme}://#{hostname}/favicon.ico"
      return url if favicon_url_ok?(url)
    end
    nil
  end

  def favicon_url_ok?(url)
    response = RestClient::Request.execute(
      method: :head,
      url: url,
      timeout: 6,
      open_timeout: 3,
      headers: { user_agent: BROWSER_USER_AGENT }
    )
    response.code == 200 && response.headers[:content_type].to_s.start_with?("image/")
  rescue => e
    Rails.logger.warn "Source#refresh_favicon HEAD failed for #{url}: #{e.class}: #{e.message}"
    false
  end

  def google_favicon_fallback
    "https://www.google.com/s2/favicons?domain=#{hostname}&sz=64"
  end
end
