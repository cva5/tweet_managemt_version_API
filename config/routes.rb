Rails.application.routes.draw do

  current_api_routes = lambda do
    # Define latest API
    post 'sessions/login'
    post 'sessions/signup'
    delete 'sessions/logout'
    post 'sessions/forgot_password'
    post 'sessions/reset_password'

    resources :twitts
  end

  namespace :api do
    namespace :v1, &current_api_routes
  end 

  namespace :api do
    namespace :v2, &current_api_routes
  end
end
