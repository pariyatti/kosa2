class ApiController < ApplicationController
  include ActiveStorage::SetCurrent

  def today
    cards = []
    PaliWord.all.order(published_at: :desc).each do |pw|
      # TODO: put :url back when resource routes are ready:
      cards << pw.to_json.except(:url)
    end
    render json: cards
  end
end
