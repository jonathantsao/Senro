require 'json'

class Session

  def initialize(req)
    if req.cookies['_senro']
      @session_hash = JSON.parse(req.cookies['_senro'])
    else
      @session_hash = {}
    end
  end

  def [](key)
    @session_hash[key]
  end

  def []=(key, val)
    @session_hash[key] = val
  end

  def store_session(res)
    res.set_cookie('_senro', { path: "/", value: @session_hash.to_json } )
  end
end
