Rails.application.routes.draw do
  root to: 'static#root'
  scope '/api' do
    scope format: 'json' do
      resources :stamps, only: [:index, :show]
      resources :imprints, only: [:create]
      delete 'imprints', to: 'imprints#clear'
    end
  end
end
