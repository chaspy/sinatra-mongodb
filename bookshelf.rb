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
  if params.has_key?('id')
    item = params
    id = BSON::ObjectId(params['id'])
    item.delete('id')
    settings.items.update_one({'_id' => id}, item)
  else
    settings.items.insert_one params
  end
  redirect "/", 303
end

get '/edititem' do
  p params
  unless params.has_key?('id')
    redirect "/", 303
  end

  obj_id = BSON::ObjectId(params['id'])
  item_found = settings.items.find({'_id' => obj_id}, :limit => 1)
  if item_found.count == 0
    redirect "/", 303
  else
    erb :edititem, :locals => { :pagetitle => ':Edit book', :item => item_found.to_a[0] }
  end
end
