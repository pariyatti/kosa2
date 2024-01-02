class WordsOfBuddhaController < ApplicationController
  def show
    words = WordsOfBuddha.find(params[:id])
    respond_to do |format|
      format.json { render json: words }
    end
  end
end
