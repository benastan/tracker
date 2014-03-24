Tracker::Application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

  root to: 'stories#index'

  resources :stories, only: [ :new, :create, :show, :destroy ] do
    resources :story_stories, path: 'child_stories', only: [ :new ]
  end

  resources :story_stories, only: [ :create, :show, :destroy ]

  resources :story_order_positions, only: :update
end
