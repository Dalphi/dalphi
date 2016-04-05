Rails.application.routes.draw do
  root 'application#welcome'

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end
