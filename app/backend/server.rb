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

get '/users/:username' do

 username="#{params['username']}"
 collection_users = :users
 bson=client[collection_users].find(:username => username).projection(:_id => 0,:username => 1).to_a
 content_type :json
 bson[0].to_json

end


post '/users/save' do

  content= JSON.parse(request.body.read)
  collection_users = :users
  bson=client[collection_users].insert_one({ username: content["username"] })
  [200, {}, {:user => "created"}.to_json]



end