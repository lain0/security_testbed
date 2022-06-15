Rails.application.routes.draw do
  resources :posts
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get 'login' => 'login#create'

  # Defines the root path route ("/")
  # root "articles#index"
end
