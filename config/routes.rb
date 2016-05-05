Rails.application.routes.draw do
  root 'projects#index'

  devise_for :users

  resources :projects do
    resources :raw_data, except: [:show]
  end

  namespace :api, defaults: { format: 'json' } do
    get '/' => redirect('/api/v1')

    namespace :v1 do
      get '/' => 'base#who_are_you'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  get '/styleguide' => 'application#styleguide'
end
