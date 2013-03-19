require 'sinatra'
require 'omniauth'
require 'omniauth-facebook'
require './lib/facebooker'

$stdout.sync = true
$localMode = false
$token = []

get '/' do
	if $localMode then
		redirect '/index'
	else 
		redirect '/auth/facebook'
	end
end

get '/index' do
	if $localMode then
		$token = ENV['DEBUG_ACCESS']
		puts "Local mode"
	else
		$token = request.env['omniauth.auth']['credentials']['token']
	end
	puts $token
	erb :index
end

get '/words' do
	@fid = 0
	erb :words
end

get '/words/:fid' do
	@fid = params[:fid]
	erb :words
end

get '/auth/failure' do
	content_type 'application/json'
	MultiJson.encode(request.env)
end

if !$localMode then 
	use Rack::Session::Cookie

	use OmniAuth::Builder do
		provider :facebook, ENV['APP_ID'], ENV['APP_SECRET'], :scope => 'user_status,read_stream', :callback_path => '/index'
	end
end
