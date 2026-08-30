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
    update!(favicon: resolve_favicon)
  end

  # Validates the favicon a client (iOS share extension or web bookmarklet) supplied and
  # substitutes a server-resolved one when it's missing, unreachable, or a generic Google
  # fallback. Called on Source creation so the DB always holds one canonical favicon — identical
  # for web and iOS — instead of trusting whatever the client happened to extract.
  def validate_favicon(candidate)
    # Upgrade to https first: an http favicon renders on iOS but is mixed-content-blocked on the
    # https web app, so storing https keeps both clients consistent.
    candidate = candidate.to_s.strip.sub(%r{\Ahttp://}, "https://")
    return candidate if candidate.present? && !google_s2?(candidate) && favicon_url_ok?(candidate)
    resolve_favicon
  end

  private

  # detect (declared <link>) → probe /favicon.ico → Google service, all keyed on the full hostname.
  def resolve_favicon
    detect_favicon || probe_root_favicon || google_favicon_fallback
  end

  # A Google s2 URL isn't a real declaration — it's the client saying "I found nothing" — so we
  # re-resolve rather than trust it (it's often keyed on the wrong root domain and can be a blank
  # globe we can't detect over HEAD).
  def google_s2?(url)
    URI(url).host.to_s.end_with?("google.com")
  rescue URI::InvalidURIError
    false
  end

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
