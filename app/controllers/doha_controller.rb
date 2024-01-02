class DohaController < ApplicationController
  def show
    doha = Doha.find(params[:id])
    respond_to do |format|
      format.json { render json: doha }
    end
  end
end
