class Service < ApplicationRecord
  enum role: [:active_learning, :bootstrap, :machine_learning]
  enum problem_id: [:ner]

  def self.new_from_url(url)
    Service.new(params_from_url(url))
  rescue
    false
  end

  def self.params_from_url(url)
    url = URI.parse(url)
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) { |http|
      http.request(req)
    }
    JSON.parse(res.body.to_s)
  end
end
