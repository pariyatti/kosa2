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
    # NOTE: the mutation 'reverse!' is an order of magnitude faster than creating
    #       a new array and doesn't matter if it's the last call in the method
    render json: cards.sort_by {|card| card['published_at'] }.reverse!
  end
end
