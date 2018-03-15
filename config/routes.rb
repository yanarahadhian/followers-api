Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  namespace :api do
    resources :follows, only: [:index, :create] do
      collection do
        post :common
        post :block
        post :unblock
        post :subscribe
        post :unsubscribe
        post :send_email
      end
    end
  end

  root 'apipie/apipies#index'
  apipie
end
