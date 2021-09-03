Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "articles#index"

  get 'search', to: "article#search"

  resources :articles do
    resources :comments
  end
end
