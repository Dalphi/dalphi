Rails.application.routes.draw do
  root 'application#styleguide'

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  get '/styleguide' => 'application#styleguide'
end
