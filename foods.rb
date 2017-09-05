require 'rack'
require_relative './lib/senro_controller.rb'
require_relative './lib/router'

class Food

  attr_reader :name, :amount

  def self.all
    @food ||= []
  end

  def initialize(params = {})
    params ||= {}
    @name = params["name"]
    @amount = params["amount"]
  end

  def errors
    @errors ||= []
  end

  def valid?
    unless @name.present?
      errors << "Name can't be blank"
      return false
    end

    unless @amount.present?
      errors << "Amount can't be blank"
      return false
    end

    unless @amount == 0
      errors << "Amount can't be 0"
      return false
    end

    true
  end

  def save
    return false unless valid?
    Food.all << self
    true
  end

  def inspect
    { name: name, amount: amount }.inspect
  end

end


class FoodsController < SenroController
  protect_from_forgery

  def create
    @food = Food.new(params["grocery_list"])
    if @food.save
      flash[:notice] = "Saved Food successfully"
      redirect_to "/foods"
    else
      flash.now[:errors] = @food.errors
      render :new
    end
  end

  def index
    @foods = Food.all
    render :index
  end

  def new
    @food = Food.new
    render :new
  end
end

router = Router.new
router.draw do
  get Regexp.new("^/foods$"), FoodsController, :index
  get Regexp.new("^/foods/new$"), FoodsController, :new
  get Regexp.new("^/foods/(?<id>\\d+)$"), FoodsController, :show
  post Regexp.new("^/foods$"), FoodsController, :create
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
