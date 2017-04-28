require 'sinatra'
require 'config_env'
require_relative 'models/weather.rb'
require 'uri'

ConfigEnv.init("#{__dir__}/config/env.rb")

set :port, 4949

get '/' do
  @cities = [
    "San Francisco",
    "London",
    "Tokyo",
    "Moscow",
    "Cairo"
  ]

  @city = params[:city] || "San Francisco"
	weather = Weather.new(@city)
  @temp = weather.temp
  @icons = weather.icons
  erb :index
end
