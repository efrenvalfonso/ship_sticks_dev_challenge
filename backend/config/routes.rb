Rails.application.routes.draw do
  apipie

  get '', to: redirect('/api/v1')

  namespace :api do
    get '', to: redirect('/api/v1')

    namespace :v1 do
      get '', to: 'version#index'

      resource :products, only: [] do
        get 'find-best-fit'
      end
      resources :products
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
