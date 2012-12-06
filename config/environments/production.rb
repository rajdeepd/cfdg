CloudfoundryUsergroups::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  #config.serve_static_assets = false
  config.serve_static_assets = true
  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true
  config.assets.precompile += %w( *.css *.js )
  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  config.action_mailer.default_url_options = { :host => 'cfdg-test.cloudfoundry.com' }
  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5
  
  Ddb::Userstamp.compatibility_mode = true
  config.assets.precompile += Ckeditor.assets
  #user-groups
  #FEDERATED_KEY = 'AIzaSyB8IrA9iaoSnQZbagf2rGxbIOk41IRKUA8'
  #EVENTBRITE_CLIENT_ID = 'VHHM4OT2VSPEEBUSWW'
  #EVENTBRITE_CLIENT_SECRET = 'ZG7WVTHUWLLFDXHA4AIUWEVJTYDDNIYSXGWFKWBPYPCFLEBZX4'  
  #EVENTBRITE_REDIRECT_URL = 'http://user-groups.cloudfoundry.com/events/oauth_reader'
  #EVENTBRITE_ORGANIZATION_ID = '2835415942'

  #cfdg-test
  #FEDERATED_KEY = 'AIzaSyBDzBczQ51lkKiXLaS2Inx1iSRtf3SdjsI'

  #EVENTBRITE_CLIENT_ID = '5TTCXIKE42QQTVWI4L'
  #EVENTBRITE_CLIENT_SECRET = 'YMEZVG4JTYTUX4LODI457DH27EJ5EBAORLPUH3DYWEQOZ3HYWR'
  #EVENTBRITE_REDIRECT_URL = 'http://cfdg-test.cloudfoundry.com/events/oauth_reader'
  #EVENTBRITE_ORGANIZATION_ID = '2916808731'

  #cfdg
  FEDERATED_KEY = 'AIzaSyBY5e8OXkT-5f8m0z1kMLSap9fEkBWiLiU'
  EVENTBRITE_CLIENT_ID = '3LLYXJHCGX26YYHWT4'
  EVENTBRITE_CLIENT_SECRET = 'KC454JQAHL6CUOAKBBVYNWQ4NXDONSZFXNR3X6N7PANQ2F5HD7'
  EVENTBRITE_REDIRECT_URL = 'http://cfdg.cloudfoundry.com/events/oauth_reader'
  EVENTBRITE_ORGANIZATION_ID = '2916808731'

  

  FEDERATED_BASE_URL = "https://www.googleapis.com/identitytoolkit/v1/relyingparty/verifyAssertion?key=#{FEDERATED_KEY}"
  
  EVENTBRITE_URL = 'https://www.eventbrite.com'


end
