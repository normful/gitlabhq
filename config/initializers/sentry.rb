# Be sure to restart your server when you modify this file.

require 'gitlab/current_settings'
include Gitlab::CurrentSettings

if Rails.env.production?
  # allow it to fail: it may do so when create_from_defaults is executed before migrations are actually done
  begin
    sentry_enabled = current_application_settings.sentry_enabled
  rescue
    sentry_enabled = false
  end

  if sentry_enabled
    Raven.configure do |config|
      config.dsn = current_application_settings.sentry_dsn
      config.release = Gitlab::REVISION
    end
  end
end
