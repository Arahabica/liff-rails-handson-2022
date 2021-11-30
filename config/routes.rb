Rails.application.routes.draw do
  root to: 'static#root'
  get '/login', to: 'static#root'
  scope '/api' do
    mount_devise_token_auth_for 'User', at: 'auth'
  end
end
