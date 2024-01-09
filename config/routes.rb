Rails.application.routes.draw do
  get 'ping', to: 'status#ping'
  get 'status', to: 'status#status'
  get 'status/ping'
  get 'status/status'

  get 'api/v1/today.json', to: 'api#today_v1', as: 'api_today_v1'
  get 'api/v2/today.json', to: 'api#today_v2', as: 'api_today_v2'

  scope '/api/v1/today', constraints: { format: 'json' } do
    resources :pali_word, :doha, :words_of_buddha
  end

end
