require 'net/http'

# Original credits: http://blog.inquirylabs.com/2006/04/13/simple-uri-validation/

module UrlResponseChecker
  extend ActiveSupport::Concern

  def self.check_response(url)
    case Net::HTTP.get_response(URI.parse(url))
      when Net::HTTPSuccess then true
      when Net::HTTPRedirection then true
      else false
    end
  rescue
    false
  end
end
