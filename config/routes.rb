Rails.application.routes.draw do
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
