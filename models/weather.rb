require 'httparty'
require 'uri'
require 'redis'
class Weather
  def initialize(city)
    @city = city
  end

  def weather_data
    redis = Redis.new(url: "redis://redistogo:4f79128f324402f8df4eb81752cea902@barreleye.redistogo.com:11135/")
    if ! redis.get(@city).nil?
      return JSON.parse(redis.get(@city))
    else
      resp = HTTParty.get("http://api.openweathermap.org/data/2.5/weather?q=#{URI.escape(@city)}&APPID=#{ENV['API_KEY']}")
      redis.set(@city, resp.body)
      redis.expire @city, 300 # seconds = 5 minutes.

      JSON.parse(resp.body)
    end
  end

  def icons
		data = weather_data
		return [] if data.nil? || data['weather'].nil?
		data['weather'].collect do |weather|
			weather['icon'] + ".png"
		end.uniq
	end


  def temp
    data = weather_data
    return nil if data.nil? || data['main'].nil? || data['main']['temp'].nil?
    data['main']['temp'] * 9 / 5 - 459.67
  end

end
