require 'sinatra'
require 'omniauth'
require 'omniauth-facebook'
require './lib/facebooker'

$stdout.sync = true

get '/' do
	redirect '/auth/facebook'
end

get '/index' do
	@token = request.env['omniauth.auth']['credentials']['token']
	puts @token
	erb :index
end

get '/auth/failure' do
	content_type 'application/json'
	MultiJson.encode(request.env)
end

use Rack::Session::Cookie

use OmniAuth::Builder do
	provider :facebook, ENV['APP_ID'], ENV['APP_SECRET'], :scope => 'user_status,read_stream', :callback_path => '/index'
end
