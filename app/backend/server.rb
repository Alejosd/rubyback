require 'sinatra'
require 'json'
require 'mongo'

include Mongo


host = ENV['MONGO_RUBY_DRIVER_HOST'] || 'localhost'
port = ENV['MONGO_RUBY_DRIVER_PORT'] || '27017'
db= ENV['MONGO_DB'] || 'doom'

puts "Connecting to #{host}:#{port}"

client = Mongo::Client.new(["#{host}:#{port}"],:database => db,:max_pool_size => 5)
set :port, 8081

get '/users/:name' do

 username="#{params['name']}"
 collection_users = :users
 bson=client[collection_users].find(:username => username).projection(:_id => 0,:username => 1).to_a
 content_type :json
 bson.to_json
#content
end
