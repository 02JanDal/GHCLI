module Ghcli
	module Terminal
		class BaseWindow
			def initialize(term, state)
				@term = term
				@state = state
			end

			def exec
				fail :NotImplementedError
			end

			def self.exec(term, state, *args)
				win = new(term, state)
				win.exec *args
				win
			end
		end
	end
end
