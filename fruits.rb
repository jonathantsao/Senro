require 'rack'
require_relative './lib/senro_controller.rb'
require_relative './lib/router'

class FruitsController < SenroController
  protect_from_forgery

  def create
    @fruit = Fruit.new(params["fruit"])
    if @fruit.save
      flash[:notice] = "Saved fruit successfully"
      redirect_to "/fruits"
    else
      flash.now[:errors] = @fruit.errors
      render :new
    end
  end

  def index
    @fruits = Fruit.all
    render :index
  end

  def new
    @fruit = Fruit.new
    render :new
  end
end

router = Router.new
router.draw do
  get Regexp.new("^/fruits$"), FruitsController, :index
  get Regexp.new("^/fruits/new$"), FruitsController, :new
  get Regexp.new("^/fruits/(?<id>\\d+)$"), FruitsController, :show
  post Regexp.new("^/fruits$"), FruitsController, :create
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

Rack::Server.start(
 app: app,
 Port: 3000
)
