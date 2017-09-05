require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require_relative './flash'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, params = {})
    @req = req
    @res = res
    @params = req.params.merge(params)
    @already_built_response = nil
  end

  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    if already_built_response?
      raise "Can't redirect twice"
    end
    @already_built_response = true
    res.status = 302
    res['Location'] = url
    session.store_session(res)
    flash.store_flash(res)
  end

  def render_content(content, content_type)
    if already_built_response?
      raise "Can't render twice"
    end
    @already_built_response = true
    res['Content-Type'] = content_type
    res.write(content)
    session.store_session(res)
    flash.store_flash(res)
  end

  def render(template_name)
    path = "views/#{self.class.to_s.underscore}/#{template_name.to_s}.html.erb"
    template = File.read(path)
    render_template = ERB.new(template).result(binding)
    render_content(render_template, "text/html")
  end

  def session
    @session ||= Session.new(req)
  end

  def flash
    @flash ||= Flash.new(req)
  end

  def invoke_action(name)
    if protect_from_forgery? && req.request_method != "GET"
      check_authenticity_token
    else
      form_authenticity_token
    end
    self.send(name)
    render(name) unless already_built_response?
    nil
  end

  def form_authenticity_token
    @authenticity_token ||= SecureRandom.urlsafe_base64(16)
    res.set_cookie('authenticity_token', value: @authenticity_token, path: "/")
    @authenticity_token
  end

  def check_authenticity_token
    cookie = req.cookies['authenticity_token']
    unless cookie && cookie == params["authenticity_token"]
      raise "Invalid authenticity token"
    end
  end

  def protect_from_forgery?
    @@protect_from_forgery
  end

  protected

  def self.protect_from_forgery
    @@protect_from_forgery = true
  end

end
