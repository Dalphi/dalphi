require 'net/http'

# Original credits: http://blog.inquirylabs.com/2006/04/13/simple-uri-validation/

module UrlResponseChecker
  extend ActiveSupport::Concern

  def self.check_response(url)
    uri = URI.parse(url)
    Net::HTTP.new(uri.hostname, uri.port) do |http|
      http.open_timeout = 60
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
