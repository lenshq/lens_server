Rails.application.routes.draw do
  namespace :api do
  end

  scope :module => :web do
    root :to => "start#index"
  end
end
