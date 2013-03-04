class FlashUploadMiddleware
  def initialize(app,session_key)
    @app = app
    @session_key = session_key
  end

  def call(env)
    env['HTTP_COOKIE'] = "bugfix=true" unless env['HTTP_COOKIE']
    if env['HTTP_USER_AGENT'] =~ /^(Adobe|Shockwave) Flash/
      req = Rack::Request.new( env )
      req.cookies[ @session_key ] = req["session_id"] unless req["session_id"].nil?
    end
    @app.call(env)
  end

end
