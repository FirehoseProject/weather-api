require 'sinatra'
require 'config_env'
require_relative 'models/weather.rb'
require 'uri'
require 'json'
require 'sinatra/json'


ConfigEnv.init("#{__dir__}/config/env.rb")
REDIS = Redis.new(url: "redis://redistogo:4f79128f324402f8df4eb81752cea902@barreleye.redistogo.com:11135/")

set :port, 4949

get '/' do

 erb :index
end
get '/weather' do
  @cities = [
    'San Francisco',
    'London',
    'Tokyo',
    'Moscow',
    'Cairo'
  ]

  @city   = params[:city] || 'San Francisco'
  weather = Weather.new(@city)
  @temp   = weather.temp
  @icons  = weather.icons
  data =  {
    temp: weather.temp,
    icons: weather.icons,
    city: weather.city,
    note: "Icons Courtesy of FlatIcon.com"
  }
  json data

end
