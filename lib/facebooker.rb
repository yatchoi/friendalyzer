require 'sinatra/base'
require 'koala'

module Sinatra
	module Facebooker
		$accessToken = ENV['ACCESS']

		def bar(name)
			"#{name}bar"
		end
	
		def getFeed
			@rest = Koala::Facebook::API.new($accessToken)

			feed = @rest.fql_query("select message from status where uid=me()")
			parseFeed(feed)
		end

		def parseFeed(feed)
			wordHash = Hash.new
			wordHash.default = 0
			feed.each do |f|
				tokens = f["message"].split(" ")
				tokens.each do |t|
					t.downcase!
					t = cleanWord(t)
					wordHash[t] = wordHash[t] + 1
				end
			end
			wordHash
		end

		def cleanWord(word)
			result = word.gsub(/[^a-z ]/, '')
			result.gsub(/(.)\1{2,}\z/, '\1')
		end

	end

	helpers Facebooker
end