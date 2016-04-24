require 'sinatra'
require 'json'
require 'mongo'

include Mongo


host = ENV['MONGO_RUBY_DRIVER_HOST'] || 'localhost'
port = ENV['MONGO_RUBY_DRIVER_PORT'] || '27017'
db= ENV['MONGO_DB'] || 'doom'

puts "Connecting to #{host}:#{port}"

client = Mongo::Client.new(["#{host}:#{port}"],:database => db)

set :port, 8081

collection_users = :users

get '/users/:username' do

 username="#{params['username']}"
 documents=client[collection_users].find(:username => username).projection(:_id => 0,:username => 1).limit(1).to_a
 result={}

 documents.each do |document|
   result = document
 end

 content_type :json
 result.to_json

end

get '/users' do

  documents=client[collection_users].find().projection(:_id => 0,:username => 1).to_a
  content_type :json
  documents.to_json

end

delete '/users' do
  content= JSON.parse(request.body.read)
  puts content
  client[collection_users].find(content).delete_one
  [200, {}, {:user => "delete"}.to_json]


end

post '/users/save' do

  content= JSON.parse(request.body.read)
  client[collection_users].insert_one(content)
  [200, {}, {:user => "created"}.to_json]

end