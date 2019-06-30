require 'sinatra'

get '/' do
  erb :index, :locals => { :pagetitle => '' }
end
