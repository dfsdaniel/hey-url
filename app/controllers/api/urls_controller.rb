# frozen_string_literal: true
class Api::UrlsController < JSONAPI::ResourceController
  def index
    params[:include] = 'clicks'

    Url.order(created_at: :desc).limit(2)
  end
end
