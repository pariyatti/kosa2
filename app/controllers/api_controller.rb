class ApiController < ApplicationController
  include ActiveStorage::SetCurrent

  def today
    cards = []
    PaliWord.all.order(published_at: :desc).each do |pali_word|
      cards << pali_word.to_json
    end
    Doha.all.order(published_at: :desc).each do |doha|
      cards << doha.to_json
    end
    WordsOfBuddha.all.order(published_at: :desc).each do |words_of_buddha|
      cards << words_of_buddha.to_json
    end
    render json: cards
  end
end
