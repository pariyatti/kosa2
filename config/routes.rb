Rails.application.routes.draw do
  get 'ping', to: 'status#ping'
  get 'status', to: 'status#status'
  get 'status/ping'
  get 'status/status'

  get 'api/v1/today.json', to: 'api#today', as: 'api_today'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  scope '/api/v1/today', constraints: { format: 'json' } do
    resources :pali_word, :doha, :words_of_buddha
  end

end
