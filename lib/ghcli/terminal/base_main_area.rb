module Ghcli
	module Terminal
		class BaseMainArea
			def initialize(term, state, start_row, start_col, width, height)
				@term = term
				@state = state
				@start_row = start_row
				@start_col = start_col
				@width = width
				@height = height
			end

			def render
				@term.transform @start_row, @start_col, @width, @height do
					render_impl
				end
			end

			def render_impl
				fail :NotImplementedError
			end

			def pre_show(*args)
			end

			def commands
				{}
			end

			def aliases
				{}
			end
		end
	end
end
