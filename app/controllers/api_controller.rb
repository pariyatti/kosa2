class ApiController < ApplicationController
  include ActiveStorage::SetCurrent

  def today
    cards = []
    PaliWord.all.order(published_at: :desc).each do |pali_word|
      # TODO: put :url back when resource routes are ready:
      cards << pali_word.to_json.except(:url)
    end
    Doha.all.order(published_at: :desc).each do |doha|
      # TODO: put :url back when resource routes are ready:
      cards << doha.to_json.except(:url)
    end
    WordsOfBuddha.all.order(published_at: :desc).each do |words_of_buddha|
      # TODO: put :url back when resource routes are ready:
      cards << words_of_buddha.to_json.except(:url)
    end
    render json: cards
  end
end
