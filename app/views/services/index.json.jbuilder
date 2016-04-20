json.array!(@services) do |service|
  json.extract! service, :id, :roll, :description, :capability, :url, :title, :version
  json.url service_url(service, format: :json)
end
