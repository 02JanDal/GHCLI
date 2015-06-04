module Ghcli
	module Github
		class Issue
			attr_reader :issue

			def initialize(state, issue)
				@state = state
				if issue.is_a?(Integer) || issue.is_a?(String)
					@issue = {number: issue.to_i}
					update!
				else
					@issue = issue
				end
			end

			def update!
				@issue = @state.client.issue @state.repository_str, issue[:number]
				self
			end

			def render(term, row, width, height)
				# available fields: number, html_url, title, user.login, labels[].{name,color}, assignee.login, milestone.{title,state(open)}, comments, body
				out = @issue[:number].to_s.rjust(5).red + ' '
				out << @issue[:title].ljust(width * 0.6 - 5) + ' '
				out << ANSI::Code.move(row, width * 0.6) + @issue[:milestone][:title].cyan + ' ' if @issue[:milestone]
				out << ANSI::Code.move(row, width * 0.6 + 10) + render_labels
			end

			def render_labels
				@issue.labels.map { |l| ANSI::Code.ansi l[:name], ANSI::Code.hex_code(l[:color]).split(';') }.join(',')
			end

			def [](key)
				@issue[key]
			end
		end
	end
end
