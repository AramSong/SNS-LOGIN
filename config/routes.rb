Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/ahctahw', as: 'rails_admin'
  devise_for :users , controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get '/users/auth/kakao', to: 'users/omniauth_callbacks#kakao'
    get '/users/auth/kakao/callback', to: 'users/omniauth_callbacks#kakao_auth'
  end
  
  # get '/kakao_auth' => 'devise/session#new'
  
  root 'movies#index'
  
  resources :movies do
    member do
      post '/comments' => 'movies#create_comment'
    end
    
    collection do
      delete '/comments/:comment_id' => 'movies#destroy_comment'
      patch  '/comments/:comment_id' => 'movies#update_comment'
      get '/search_movie' =>'movies#search_movie'
    end
  end
  
  post '/uploads' => 'movies#upload_image'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get   '/likes/:movie_id' => 'movies#like_movie'
  # post  '/movies/:movie_id/comments' => 'movies#comments'
  
end