module Ghcli
	module Terminal
		class StandardWindow < BaseWindow
			def initialize(term, state)
				super(term, state)

				@areas = {}
			end

			def set_area(arg, *args)
				case arg
				when String
					arg = 'Ghcli::Terminal::Areas::' + arg.camelize
					arg = arg + 'Area' unless arg.end_with? 'Area'
					cache_key = arg + ';' + args.map(&:to_s).join(';')
					@area = @areas[cache_key] ||= arg.constantize.new(@term, @state)
					@area.pre_show *args
					@commands = default_commands.merge @area.commands
					@aliases = default_aliases.merge @area.aliases
				when Symbol
					set_area arg.to_s, *args
				when Class
					set_area arg.to_s, *args
				when Object
					set_area arg.class.to_s, *args
				end
			end

			def exec
				@term.reset
				@state ||= Ghcli::State.new @term
				set_area :list_issues
				update_screen

				while buf = Readline.readline('> ', true)
					line = buf.match /^([^\s]*)(\s(.*))?$/
					update_screen and next if line.nil?
					command = line[1]
					update_screen and next if command.empty?
					command = command.to_sym

					begin
						fail CommandError.new "Unknown command: #{command}" unless @commands.key?(command) || @aliases.key?(command)

						cmd = @commands[command] || @commands[@aliases[command]]
						cmd[:do].call line[3]
						update_screen
					rescue CommandError => e
						update_screen
						@term.move :bottom
						print e.message.yellow.bold.rjust(@term.width)
						@term.move :bottom, 0
					end
				end
			rescue Interrupt
				puts ''
			ensure
				@state.save! if @state
				puts 'Bye!'
			end

			private

			def default_commands
				{
					quit: {
						do: lambda { |_| exit }
					},
					eval: {
						do: lambda { |str| EvalWindow.exec @term, @state, str }
					},
					show: {
						do: lambda { |str| set_area :show_issue, str }
					},
					list: {
						do: lambda { |_| set_area :list_issues }
					},
					web: {
						do: lambda do |str|
							fail Ghcli::CommandError, 'No issue given' if str.nil? || str.empty?
							Ghcli::Util.open_issue_in_web @state, str
						end
					}
				}
			end

			def default_aliases
				{
					exit: :quit,
					q: :quit
				}
			end

			def update_screen
				@term.reset
				@term.dash_row 2
				@term.dash_row @term.height - 1
				@term.move 1
				@term.print_at 1, @state.org.yellow + '/' + @state.repo.yellow + ' as ' + @state.current_user.green
				@area.render
				@term.move :bottom
			end
		end
	end
end
