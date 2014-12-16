Digiramp::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local          = true
  config.action_controller.perform_caching    = true
  config.cache_store                          = :dalli_store

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors  = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation           = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error        = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
  
  Rails.application.routes.default_url_options[:host] = 'localhost:3000'
  
  
end


ActionMailer::Base.smtp_settings = {
    :address => "smtp.sendgrid.net",
    :port => 587,
    :domain => "localhost:3000",
    :authentication => :plain,
    :user_name => "info-digiramp",
    :password => "GnoDg4jq7Wm"
}


ENV["MAIL_USERNAME"]    = 'info@digiramp.org'
ENV["MAIL_PASSWORD"]    = 'IS5pleyu'

ENV["S3_KEY_ID"]        = 'AKIAJN4UDAY5IF3CRYDA'
ENV["S3_ACCESS_KEY"]    = 'UDH4rSx4N6A267q/Tii+K+9APoElnIQzwdlqo530'
ENV["AWS_S3_BUCKET"]    = 'digiramp-widget'

#ENV['TWITTER_KEY']      = 'sxnwvjajuSgGiWWVlWMRXj6Qq'
#ENV['TWITTER_SECRET']   = 'HVZQ8tlkDGTeOvaZnFjK4vAwmHPyfHtzDg6tbu98gslj6moCh9'
ENV['TWITTER_KEY']      = 'sxnwvjajuSgGiWWVlWMRXj6Qq'
ENV['TWITTER_SECRET']   = 'HVZQ8tlkDGTeOvaZnFjK4vAwmHPyfHtzDg6tbu98gslj6moCh9'


# development DigiRAMP test 1
ENV['FACEBOOK_KEY']      = '493734500765975'
ENV['FACEBOOK_SECRET']   = '36d8271d6555d58d0ce252150d1301cb'




ENV['LINKEDIN_KEY']      = '77geot159kgi5l'
ENV['LINKEDIN_SECRET']   = 'VztOr48kHMunUq1L'

ENV['GPLUS_KEY']         = '49205251565-g2eq19fs28jcuotor86o9ls075nnovnk.apps.googleusercontent.com'
ENV['GPLUS_SECRET']      = 'Ox9KrfvCX9FCrTEyPBb6oQ94'



