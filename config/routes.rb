Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :applications do
        scope module: :applications do
          resources :requests
        end
      end

      resource :data, only: [] do
        collection do
          post :rec
        end
      end
    end
  end

  scope module: :web do
    root to: "start#index"

    resources :applications do
      member do
        get :query
      end
    end


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
