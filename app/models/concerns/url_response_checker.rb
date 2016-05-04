require 'net/http'

# Original credits: http://blog.inquirylabs.com/2006/04/13/simple-uri-validation/

module UrlResponseChecker
  extend ActiveSupport::Concern

  def check_response(url)
    if !url.nil? && !url.empty?
      case Net::HTTP.get_response(URI.parse(url))
        when Net::HTTPSuccess then true
        else false
      end
    end
  rescue
    false
  end
end
