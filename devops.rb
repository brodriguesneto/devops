require 'sinatra'
require 'redis'
require 'json'
require 'csv'

redis = Redis.new

get '/' do
  'Deploy Time Series API'
end

post '/api/v1' do
  payload = JSON.parse(request.body.read)
  payload["date"] = Time.now 
  redis.incr(payload.to_json)
end

get '/api/v1/list' do
  content_type :json
  JSON.pretty_generate(redis.keys('*'))
end

get '/api/v1/download' do
  content_type 'application/csv'
  attachment "download.csv"
  JSON.pretty_generate(redis.keys('*'))
end