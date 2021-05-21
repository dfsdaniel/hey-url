class Api::ClickResource < ApplicationResource
  attributes :created_at, :platform, :browser
  has_one :url, exclude_links: :default, always_include_linkage_data: false

  exclude_links [:self]
end