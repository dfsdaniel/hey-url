# frozen_string_literal: true
class Api::ClicksController < JSONAPI::ResourceController
  def index
    params[:include] = 'url'
    super
  end
end
