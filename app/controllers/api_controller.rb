class ApiController < ApplicationController
  include ActiveStorage::SetCurrent

  def today_v1
    cards = []
    PaliWord.all.order(published_date: :desc).each do |pali_word|
      cards << pali_word
    end
    Doha.all.order(published_date: :desc).each do |doha|
      cards << doha
    end
    WordsOfBuddha.all.order(published_date: :desc).each do |words_of_buddha|
      cards << words_of_buddha
    end
    render json: remove_future(reverse_chrono(cards))
  end

  def today_v2
    cards = []
    PaliWord.all.order(published_date: :desc).each do |pali_word|
      cards << pali_word
    end
    Doha.all.order(published_date: :desc).each do |doha|
      cards << doha
    end
    WordsOfBuddha.all.order(published_date: :desc).each do |words_of_buddha|
      cards << words_of_buddha
    end
    render json: reverse_chrono(cards)
  end

  def reverse_chrono(cards)
    # NOTE: the mutation 'reverse!' is an order of magnitude faster than creating
    #       a new array and doesn't matter if it's the last call in the method
    cards.sort_by { |card| [card['published_date'], card['published_at']] }.reverse!
  end

  def remove_future(cards)
    cards.reject {|c| c.published_date > Date.today }
  end
end
