# confg: utf-8
require 'sinatra'
require 'mongo'

configure do
  client = Mongo::Client.new([ 'mongo0:27017' ], :database => 'bookshelf')
  set :items, client[:items]
end

get '/' do
  items = settings.items.find()
  erb :index, :locals => { :pagetitle => '', :items => items }
end

get '/additem' do
  erb :additem, :locals => { :pagetitle => ': Add book' }
end

post '/update_action' do
  settings.items.insert_one params
  redirect "/", 303
end
