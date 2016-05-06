Rails.application.routes.draw do
  root 'projects#index'

  devise_for :users

  resources :services, only: [:index, :create]
  resources :projects do
    resources :raw_data, except: [:show]
  end

  namespace :api, defaults: { format: 'json' } do
    get '/' => redirect('/api/v1')

    namespace :v1 do
      get '/' => 'base#who_are_you'
    end
  end

  put '/services/:id', to: 'services#update', constraints: { id: /[0-9]+/ }, as: 'service'
  patch '/services/:id', to: 'services#update', constraints: { id: /[0-9]+/ }
  delete '/services/:id', to: 'services#destroy', constraints: { id: /[0-9]+/ }

  get '/services/:id/edit', to: 'services#edit', constraints: { id: /[0-9]+/ }, as: 'edit_service'

  get '/services/new', to: 'services#new', as: 'new_service'
  get '/services/:role', to: 'services#role_services', constraints: { id: /[a-zA-Z]+.*/ }, as: 'role_service'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  get '/styleguide' => 'application#styleguide'
end
