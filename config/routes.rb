Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  namespace :api do
    resources :followers, only: [:index, :create] do
      collection do
        post :common
      end
    end

    resources :subscribes, only: [:create] do
      collection do
        post :block
        post :send_email
        post :unblock
      end
    end
  end

  root 'apipie/apipies#index'
  apipie
end
