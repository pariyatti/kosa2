class PaliWordController < ApplicationController
  def show
    pali = PaliWord.find(params[:id])
    respond_to do |format|
      format.json { render json: pali }
    end
  end
end
