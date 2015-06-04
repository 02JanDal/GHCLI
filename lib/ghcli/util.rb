require 'launchy'

module Ghcli
	class Util
		def self.clean_issue_id(str)
			str.sub /^(GH\-|#)/, ''
		end

		def self.open_issue_in_web(state, str)
			fail CommandError.new 'Invalid issue format. Required format: [GH-|#|]<number>' unless str =~ /^(GH\-|#)?\d+/
			issue = Util.clean_issue_id str
			url = "https://github.com/#{state.org}/#{state.repo}/issues/#{issue}"
			Launchy.open url
		end
	end
end
