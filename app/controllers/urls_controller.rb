# frozen_string_literal: true
class UrlsController < ApplicationController
  def index
    @url = Url.new
    @urls = Url.order(created_at: :desc).limit(10)
  end

  def create
    existingUrl = Url.find_by(original_url:params[:url][:original_url])
    if existingUrl.present?
      flash.notice = "This URL already have a short URL: #{root_url}#{existingUrl.short_url}"
      redirect_back(fallback_location: root_path)
      return
    end

    newUrl = Url.new(original_url: params[:url][:original_url])
    newUrl.generate_short_url_code()

    begin
      newUrl.save!
    rescue => error
      flash.notice = 'This URL is not valid. Please try again.'
    end
    
    redirect_back(fallback_location: root_path)
  end

  def show
    @url = Url.find_by(short_url: params[:url])

    render 'errors/404', status: 404 if @url.nil?
    return if @url.nil?

    day_clicks_records = Click
      .where(url_id: @url.id, created_at:Date.today.all_month)
      .group('DATE(created_at)').count
    browsers_clicks_records = Click.where(url_id: @url.id).group(:browser).count
    platform_clicks_records = Click.where(url_id: @url.id).group(:platform).count

    days_total = [];
    day_clicks_records.keys.each do |key|
      days_total.push([key.strftime('%d'), day_clicks_records[key]])
    end

    browsers_total = [];
    browsers_clicks_records.keys.each do |key|
      browsers_total.push([key, browsers_clicks_records[key]])
    end

    platform_total = [];
    platform_clicks_records.keys.each do |key|
      platform_total.push([key, platform_clicks_records[key]])
    end

    @daily_clicks = days_total
    @browsers_clicks = browsers_total
    @platform_clicks = platform_total
  end

  def visit
    url = Url.find_by(short_url: params[:short_url])

    render 'errors/404', status: 404 if url.nil?
    return if url.nil?

    new_click = Click.new(url: url, browser: browser.name, platform: browser.platform.name)
    new_click.save!

    url.increment(:clicks_count)
    url.save

    redirect_to url.original_url
  end
end
