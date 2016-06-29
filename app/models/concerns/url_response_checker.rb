require 'net/http'

module UrlResponseChecker
  extend ActiveSupport::Concern

  def self.check_response(url)
    uri = URI.parse(url)
    timeout = Rails.configuration.x.dalphi['timeouts']['url-response-checker']
    Timeout::timeout(timeout) do
      response = Net::HTTP.get_response(uri)
      return response.kind_of?(Net::HTTPSuccess) || response.kind_of?(Net::HTTPRedirection)
    end
  rescue
    false
  end
end
