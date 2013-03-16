require 'sinatra/base'
require 'koala'

module Sinatra
	module Facebooker
		$accessToken = "";

		def bar(name)
			"#{name}bar"
		end
	
		def getFeed
			@rest = Koala::Facebook::API.new($accessToken)

			feed = @rest.fql_query("select message from status where uid=me()")
			feed
		end

		def parseFeed(feed)

		end
	end

	helpers Facebooker
end