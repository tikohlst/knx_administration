require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module KnxAdministration
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.time_zone = 'Berlin'
    config.active_record.default_timezone = :local

    # Whitelist locales available for the application
    config.i18n.available_locales = [:en, :de]

    # Default language
    config.i18n.default_locale = :en

    # Save the search params for each user
    $widgets_search_params = {}
    $users_search_params = {}

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # fonts
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/
  end
end
