class VideosController < ApplicationController
  def index
    render json: Video.order(release_time: :desc).all
  end

  def search
    where = <<~SQL
      lower(concat(description, name)) 
      LIKE lower(concat('%', ?, '%'))
    SQL
    render json: Video.where(where, params[:q])
  end
end
