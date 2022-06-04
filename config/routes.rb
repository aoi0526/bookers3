Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  get 'chats/show'
  get 'searches/search'
  get 'home/about' => 'homes#about'
  get '/search', to: 'searches#search'
  get 'chat/:id', to: 'chats#show', as: 'chat'

  resources :chats, only: [:create]

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end

  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get :followings, on: :member
    get :followers, on: :member
  end

  resources :groups do
    get "join" => "groups#join"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
