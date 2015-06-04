require 'io/console'

module Ghcli
	module Terminal
		class AskLoginWindow < BaseWindow
			attr_accessor :username
			attr_accessor :password

			def exec
				@term.reset
				@username = Readline.readline 'Username: '
				@password = STDIN.noecho { Readline.readline 'Password: ' }
				@term.reset
			end
		end
	end
end
