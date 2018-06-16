Rails.application.routes.draw do

  scope :api do
    scope :v1 do
      scope :auth do
        post 'login' => 'authenticate#login'
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :apartments
    end
  end
end
