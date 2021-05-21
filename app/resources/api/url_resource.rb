class Api::UrlResource < ApplicationResource
  attributes :created_at, :original_url, :url, :clicks
  has_many :clicks, exclude_links: :default, always_include_linkage_data: true

  exclude_links [:self]

  def clicks
    @model.clicks_count
  end

  def url
    "http://localhost:3000/#{@model.short_url}"
  end 
end