require 'sinatra/base'
require 'koala'

module Sinatra
	module Facebooker
		$accessToken = "";
		$wordHash = Hash.new
		$wordHash.default = 0

		def bar(name)
			"#{name}bar"
		end
	
		def getFeed
			@rest = Koala::Facebook::API.new($accessToken)

			feed = @rest.fql_query("select message from status where uid=me()")
			parseFeed(feed)
			feed
		end

		def parseFeed(feed)
			feed.each do |f|
				tokens = f["message"].split(" ")
				tokens.each do |t|
					t.downcase!
					$wordHash[t] += 1
				end
			end
			puts $wordHash
		end
	end

	helpers Facebooker
end