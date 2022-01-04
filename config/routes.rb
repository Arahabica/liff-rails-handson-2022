Rails.application.routes.draw do
  root to: 'static#root'
  get '/login', to: 'static#root'
  scope '/api' do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      registrations: 'line_token_auth/registrations',
      sessions: 'line_token_auth/sessions'
    }
    scope format: 'json' do
      resources :stamps, only: [:index, :show]
    end
    scope format: 'json' do
      resources :imprints, only: [:create]
    end
    get 'config/liff_id', to: 'config#liff_id'
  end
  get '/hello', to: 'hello#index'
end
