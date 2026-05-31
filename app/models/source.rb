require "nokogiri"
require "rest-client"
require "uri"

class Source < ActiveRecord::Base
  has_many :quotes

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
    update!(favicon: detect_favicon || google_favicon_fallback)
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
        next if svg_favicon?(el, href)
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
    RestClient::Request.execute(method: :get, url: url, timeout: 8, open_timeout: 4).body
  rescue => e
    Rails.logger.warn "Source#refresh_favicon fetch failed for #{url}: #{e.class}: #{e.message}"
    nil
  end

  def google_favicon_fallback
    "https://www.google.com/s2/favicons?domain=#{hostname}&sz=32"
  end

  def svg_favicon?(el, href)
    el["type"].to_s.downcase.include?("svg") ||
      href.split("?").first.to_s.downcase.end_with?(".svg")
  end
end
