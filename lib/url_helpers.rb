module UrlHelpers
  extend ActiveSupport::Concern

  def register_with_cpath(provider)
    "#{OmniAuth.config.path_prefix}/#{provider.to_s}"
  end
end
