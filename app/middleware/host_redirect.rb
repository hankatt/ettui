class HostRedirect
  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    if req.host == "ettui.com"
      target = "https://www.ettui.com#{req.fullpath}"
      [301, { "Location" => target, "Content-Type" => "text/html" }, ["Redirecting to #{target}"]]
    else
      @app.call(env)
    end
  end
end
