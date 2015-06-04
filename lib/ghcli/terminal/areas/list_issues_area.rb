module Ghcli
	module Terminal
		module Areas
			class ListIssuesArea < BaseMainArea
				def render_impl
					@term.print_at :bottom, '> '
					issues = @state.issues.slice @state.issue_offset || 0, @term.height - 4
					issues ||= []
					@term.print_list 3, issues do |issue, row|
						issue.render @term, row, @term.width, 1
					end
				end

				def commands
					{
						update: {
							do: lambda { |_| @state.reset_issues! }
						}
					}
				end
			end
		end
	end
end
