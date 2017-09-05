require 'json'

class Flash

  attr_reader :now, :flash

  def initialize(req)
    if req.cookies['_rails_lite_app_flash']
      @now = JSON.parse(req.cookies['_rails_lite_app_flash'])
    else
      @now = {}
    end
    @flash = {}
  end

  def [](key)
    flash[key.to_s] || now[key.to_s]
  end

  def []=(key, val)
    flash[key.to_s] = val
  end

  def store_flash(res)
    res.set_cookie('_rails_lite_app_flash', { path: "/", value: flash.to_json } )
  end

end
