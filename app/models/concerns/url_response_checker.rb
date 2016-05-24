require 'net/http'

module UrlResponseChecker
  extend ActiveSupport::Concern

  def self.check_response(url)
    uri = URI.parse(url)
    timeout = Rails.configuration.x.dalphi['timeouts']['url-response-checker']

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
