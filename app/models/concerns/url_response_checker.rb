require 'net/http'

module UrlResponseChecker
  extend ActiveSupport::Concern

  def self.check_response(url)
    uri = URI.parse(url)
    ap Rails.application.config.dalphi
    timeout = Rails.application.config.dalphi['timeouts']['url-response-checker'].to_i

    Net::HTTP.new(uri.hostname, uri.port) do |http|
      http.open_timeout = timeout
      case http.request_get(uri.request_uri)
        when Net::HTTPSuccess then true
        when Net::HTTPRedirection then true
        else false
      end
    end
  rescue
    false
  end
end
