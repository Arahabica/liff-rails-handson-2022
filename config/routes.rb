Rails.application.routes.draw do
  root to: 'static#root'
  scope '/api' do
    scope format: 'json' do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'line_token_auth/registrations',
        sessions: 'line_token_auth/sessions'
      }
      resources :stamps, only: [:index, :show]
      resources :imprints, only: [:create]
      delete 'imprints', to: 'imprints#clear'
      get '/hello', to: 'hello#index'
      get 'config/liff_id', to: 'config#liff_id'
    end
  end
end
