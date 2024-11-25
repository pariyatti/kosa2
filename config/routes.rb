Rails.application.routes.draw do
  get 'ping', to: 'status#ping'
  get 'status', to: 'status#status'
  get 'status/ping'
  get 'status/status'

  # NOTE: for now, APIs are versioned individually, not globally

  get 'api/v1/today.json', to: 'api#today_v1', as: 'api_today_v1'
  get 'api/v2/today.json', to: 'api#today_v2', as: 'api_today_v2'

  scope '/api/v1/today', constraints: { format: 'json' } do
    # TODO: controllers should be plural? (or added to inflections.rb)
    resources :pali_word, :doha, :words_of_buddha
  end

  scope '/api/v1/library', constraints: { format: 'json' } do
    resources :videos
  end
end
