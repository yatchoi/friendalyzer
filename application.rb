require 'sinatra'
require './lib/facebooker'

$stdout.sync = true

get '/' do
	erb :index
end

get '/:name' do
	bar(params[:name])
end

get '/facebook' do
	auth
end
