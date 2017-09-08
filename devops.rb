require 'sinatra'
require 'redis'
require 'json'

set :bind, '0.0.0.0'
set :public_folder, File.dirname(__FILE__) + './public/'

redis = Redis.new

get '/' do
  send_file 'public/index.html'
end

get '/style.css' do
  send_file 'public/style.css'
end

post '/api/v1/' do
  begin
    payload = JSON.parse(request.body.read)
    payload["date"] = Time.now
    redis.incr(payload.to_json)
    status 201
  rescue
    cache_control :public, :max_age => 30
    status 501
  end
end

get '/api/v1/' do
  content_type :json
  JSON.pretty_generate(redis.keys('*')).delete!('\\')
end