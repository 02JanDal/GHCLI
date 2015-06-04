module Ghcli
	module Terminal
		class EvalWindow < Ghcli::Terminal::BaseWindow
			def exec(str)
				@term.reset
				puts eval(str).inspect
				puts 'Press enter key to continue'
				gets
			end
		end
	end
end
