class Static

  attr_reader :app, :root, :file_giver

  def initialize(app)
    @app = app
    @root = :public
    @file_giver = FileGiver.new(@root)
  end

  def call(env)
    req = Rack::Request.new(env)
    path = req.path
    if path.include?("/#{root}/")
      res = @file_giver.call(env)
    else
      res = app.call(env)
    end

    res
  end
end

class FileGiver

  TYPES = {
    '.txt' => "text/plain",
    '.jpg' => "image/jpeg",
    '.png' => "image/png",
    '.zip' => "application/zip",
    '.htm' => "text/html",
    '.html' => "text/html"
  }

  def initialize(root)
    @root = root
  end

  def call(env)
    file_name = file_request(env)
    res = Rack::Response.new
    if File.exist?(file_name)
      file_response(file_name, res)
    else
      res.status = 404
      res.write("File not found")
    end
    res
  end


  private

  def file_response(file_name, res)
    content_type = TYPES[File.extname(file_name)]
    file = File.read(file_name)
    res["Content-type"] = content_type
    res.write(file)
  end

  def file_request(env)
    req = Rack::Request.new(env)
    path = req.path
    directory_path = File.dirname(__FILE__)
    File.join(directory_path, "..", path)
  end

end
