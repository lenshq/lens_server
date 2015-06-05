Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :data, only: [] do
        collection do
          post :rec
        end
      end
    end
  end

  scope module: :web do
    root to: "start#index"

    resources :applications


    resource :user, only: [:index] do
      scope module: :user do
        resource :session, :only => [:new, :destroy]
        resource :network, :only => [] do
          get :failure, :on => :member
        end
        resource :github, :only => [] do
          get :callback, :on => :member
        end
      end
    end
  end
end
