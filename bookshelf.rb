# confg: utf-8
require 'sinatra'
require 'mongo'

configure do
  client = Mongo::Client.new([ ENV['MONGO_HOST'] + ":" + ENV['MONGO_PORT'] ], :database => 'bookshelf')
  set :items, client[:items]
end

get '/' do
  all_items = settings.items.find()
  erb :index, :locals => { :pagetitle => '', :items => all_items, :searchtext => nil }
end

post '/' do
  unless params.has_key?('searchtext')
    redirect '/', 303
  end
  search_regexp = Regexp.new('.*' + params['searchtext'] + '.*')
  find_items = settings.items.find(:title => search_regexp)
  erb :index, :locals => { :pagetitle => '',
                           :items => find_items,
                           :searchtext => params['searchtext'] }
end

get '/additem' do
  erb :additem, :locals => { :pagetitle => ': Add book' }
end

post '/update_action' do
  authors = params['author'].split(',')
  params['author'] = authors

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

get '/itemdetail' do
  p params
  unless params.has_key?('id')
    redirect "/", 303
  end

  obj_id = BSON::ObjectId(params['id'])
  item_found = settings.items.find({'_id' => obj_id}, :limit => 1)
  if item_found.count == 0
    redirect "/", 303
  else
    erb :itemdetail, :locals => { :pagetitle => ':Show book detail', :item => item_found.to_a[0] }
  end
end

helpers do
  def show_authors(authors)
    authors.is_a?(Array) ? authors.join(',') : authors
  end
end
