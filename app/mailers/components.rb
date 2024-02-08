# frozen_string_literal: true

module Components
  extend ActiveSupport::Concern

  included do
    helper_method :frontend_url
  end

  # @param path [String, nil]
  # @return [String]
  #  Returns the frontend URL with the given path safely appended.
  def frontend_url(path = nil)
    url = ENV.fetch('FRONTEND_URL')
    path ? [url, path].join('/').gsub(%r{(?<!:)//}, '/') : url
  end
end
