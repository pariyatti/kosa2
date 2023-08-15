class ApiController < ApplicationController
  include ActiveStorage::SetCurrent

  def today
    cards = []
    PaliWord.all.order(published_at: :desc).each do |pali_word|
      cards << pali_word
    end
    Doha.all.order(published_at: :desc).each do |doha|
      cards << doha
    end
    WordsOfBuddha.all.order(published_at: :desc).each do |words_of_buddha|
      cards << words_of_buddha
    end
    render json: cards
  end
end
