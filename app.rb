require 'sinatra'
require 'config_env'
require_relative 'models/weather.rb'
require 'uri'

ConfigEnv.init("#{__dir__}/config/env.rb")
REDIS = Redis.new(url: "redis://redistogo:4f79128f324402f8df4eb81752cea902@barreleye.redistogo.com:11135/")

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
