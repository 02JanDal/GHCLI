module Ghcli
	module Terminal
		class AskCurrentWindow < BaseWindow
			def exec
				org = nil
				repo = nil
				while true
					@term.reset
					org = Readline.readline "Organization [#{org || @state.org}]: "
					repo = Readline.readline "Repository [#{repo || @state.repo}]: "
					break if @state.client.repository? owner: org, name: repo
				end
				@state.org = org
				@state.repo = repo
			end
		end
	end
end
