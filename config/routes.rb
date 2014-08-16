Tracker::Application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

  root to: 'stories#index'

  resources :stories, only: [ :new, :create, :show, :destroy, :update ] do
    resources :child_stories, only: [ :new ]
    resource :parent_stories, only: [ :edit ]
  end

  resources :story_stories, only: [ :create, :show, :destroy ]

  resources :story_order_positions, only: :update

  if Rails.env.test? || Rails.env.development?
    resource :file_preview, only: [:show]
  end
end
