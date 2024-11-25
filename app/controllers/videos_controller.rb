class VideosController < ApplicationController
  def index
    render json: Video.order(release_time: :desc).all
  end
end
