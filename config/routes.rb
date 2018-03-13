Rails.application.routes.draw do

  resources :categories
  root "events#index"

  get 'events/filter/:scope' => "events#index", as: :filtered_events

  resources :events do
    resources :registrations
    resources :likes
  end
  
  resources :users
  get 'signup' => 'users#new'

  resource :session

end
