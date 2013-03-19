require 'sinatra/base'
require 'sinatra/contrib'
require 'koala'

module Sinatra
	module Facebooker

		def getFriends(token)
			rest = Koala::Facebook::API.new(token)

			friends = rest.fql_query("SELECT id, name FROM profile WHERE id IN (SELECT uid2 from friend where uid1=me()) ORDER BY name")
			friends
		end
	
		def getFeed(token, fid)
			rest = Koala::Facebook::API.new(token)

			if fid == '0' then
				fid = "me()"
			end

			feed = rest.fql_query("select message from status where uid=" + fid)
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