Rails.application.routes.draw do
  apipie

  namespace :api do
    namespace :v1 do
      resource :products, only: [] do
        get 'find-best-fit'
      end
      resources :products
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
