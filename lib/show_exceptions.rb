require 'erb'

class ShowExceptions

  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      @app.call(env)
    rescue Exception => e
      render_exception(e)
    end
  end

  private

  def render_exception(e)
    directory_path = File.dirname(__FILE__)
    template_file_name = [directory_path, "templates", "rescue.html.erb"].join("/")
    template = File.read(template_file_name)
    template_erb = ERB.new(template).result(binding)
    ['500', {'Content-type' => 'text/html'}, [template_erb]]
  end

end
