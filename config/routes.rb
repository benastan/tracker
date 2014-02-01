Tracker::Application.routes.draw do
  root to: 'stories#index'
  resources :stories, only: [ :new, :create ]
end
