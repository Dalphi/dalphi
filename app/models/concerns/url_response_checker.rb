require 'net/http'

module UrlResponseChecker
  extend ActiveSupport::Concern

  def self.check_response(url)
    uri = URI.parse(url)
    timeout = Rails.configuration.x.dalphi['timeouts']['url-response-checker']

    client = Net::HTTP.new(uri.hostname, uri.port) do |http|
      http.open_timeout = timeout
      case http.request_get(uri.request_uri)
        when response.kind_of?(Net::HTTPSuccess) then return true
        else return false
      end
    end

    return true if client
    false
  rescue
    false
  end
end
