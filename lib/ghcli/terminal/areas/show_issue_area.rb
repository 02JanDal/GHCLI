require 'colorize'

module Ghcli
	module Terminal
		module Areas
			class ShowIssueArea < BaseMainArea
				def render_impl
					out = []
					out << 'Title: '.bold + @issue[:title]
					out << 'Labels: '.bold + @issue.render_labels
					out << 'Milestone: '.bold + @issue[:milestone][:title].cyan if @issue[:milestone]
					out << 'Creator: '.bold + @issue[:user][:login].green
					out << 'Assignee: '.bold + @issue[:assignee][:login].green if @issue[:assignee]
					out << 'Body: '.bold + @issue[:body] unless @issue[:body].empty?
					out << 'Comments: '.bold + @issue[:comments].to_s

					@term.print_at 3, out.join("\n")
				end

				def pre_show(issue)
					@issue_id = Ghcli::Util.clean_issue_id issue
					@issue = @state.issue @issue_id
					@issue.update!
				end

				def commands
					{
						web: {
							do: lambda do |str|
								Ghcli::Util.open_issue_in_web @state, (str || @issue[:number].to_s)
							end
						},
						update: {
							do: lambda { |_| @issue.update! }
						}
					}
				end
			end
		end
	end
end
