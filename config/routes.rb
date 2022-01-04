Rails.application.routes.draw do
  root to: 'static#root'
  scope '/api' do
    scope format: 'json' do
      resources :stamps, only: [:index, :show]
    end
    scope format: 'json' do
      resources :imprints, only: [:create]
    end
  end
end
