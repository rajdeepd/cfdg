Rails.application.config.middleware.use OmniAuth::Builder do

  OmniAuth.config.logger = Logger.new(STDOUT)
  OmniAuth.logger.progname = "omniauth"

  provider :facebook, "543305615699970", "5eeeadf96ed1c5dca0583fa11ad4e77f"
  #provider :twitter, "XDoB4a1h0MOhsvJX6EieQQ", "MBdijWKkZ2pnGvvyjG80p5Vymb9IE08BFvu6FdFbno"
  provider :linkedIn, "8l32hbmh7udx", "XsBya4XE3gFCp9Gw"
  provider :google, "94772855995.apps.googleusercontent.com", "lcslMhoyxjTZJq78ujSiPgEe"
  provider :yahoo, "dj0yJmk9cjNZS1hDSWUxMnVGJmQ9WVdrOWNHNTZhVVZ2TnpZbWNHbzlNVGMxTWpJNU16ZzJNZy0tJnM9Y29uc3VtZXJzZWNyZXQmeD01YQ--","32157a8754acfca3da5ae9cdc167e840321098fb"
end