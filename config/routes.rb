Rails.application.routes.draw do
  root to: redirect('/projects')

  devise_for :users

  # API

  namespace :api, defaults: { format: 'json' } do
    get '/' => redirect('/api/v1')

    resources :docs, only: [:index]

    namespace :v1 do
      get '/' => 'who_are_you#who_are_you'

      resources :annotation_documents, only: [:create, :show, :update, :destroy]
    end
  end

  # Services

  resources :services, only: [:index, :create]

  put '/services/:id',
      to: 'services#update',
      constraints: { id: /\d+/ },
      as: 'service'
  patch '/services/:id',
        to: 'services#update',
        constraints: { id: /\d+/ }
  patch '/services/:id/refresh',
        to: 'services#refresh',
        constraints: { id: /\d+/ },
        as: 'refresh_service'
  delete '/services/:id',
         to: 'services#destroy',
         constraints: { id: /\d+/ }
  get '/services/:id/edit',
        to: 'services#edit',
        constraints: { id: /\d+/ },
        as: 'edit_service'
  get '/services/new',
      to: 'services#new',
      as: 'new_service'
  get '/services/:role',
      to: 'services#role_services',
      constraints: { role: /\D+\w*/ },
      as: 'role_service'
  get '/services/:id/check_connectivity',
      to: 'services#check_connectivity',
      constraints: { id: /\d+/ },
      as: 'check_connectivity'

  # Projects

  resources :projects do
    resources :statistics, only: [:index]

    resources :raw_data, except: [:show] do
      resources :annotation_documents, only: [:index, :show]
    end

    resources :annotation_documents, only: [:index, :show]

    # Annotation Documents

    get '/annotate',
        to: 'annotations#annotate',
        as: 'annotate'
    get '/annotate/:annotation_document_id',
        to: 'annotations#annotate',
        constraints: { annotation_document_id: /\d+/ },
        as: 'annotate_document'
    patch '/annotation_documents/next',
          to: 'annotation_documents#next',
          as: 'next_annotation_documents'
  end

  post '/projects/:id/iterate',
      to: 'projects#iterate',
      as: 'project_iterate'
  post '/projects/:id/merge',
      to: 'projects#merge',
      as: 'project_merge'
  get '/projects/:id/check_problem_identifiers',
      to: 'projects#check_problem_identifiers',
      constraints: { id: /\d+/ },
      as: 'check_problem_identifiers'
  get '/projects/:id/check_interfaces',
      to: 'projects#check_interfaces',
      constraints: { id: /\d+/ },
      as: 'check_interfaces'

  # Interfaces

  resources :interfaces
  post '/interfaces/:id',
       to: 'interfaces#refresh',
       as: 'refresh_interface'

  # For details on the DSL available within this file,
  # see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  get '/styleguide' => 'application#styleguide'
end
