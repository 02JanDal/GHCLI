require 'octokit'
require 'faraday-http-cache'
require 'yaml'
require 'configliere'

Settings.use :commandline
Settings({
	access_token: nil,
	current: {
		org: nil,
		repo: nil
	}
})
Settings.define 'access_token'
Settings.define 'current.org', description: 'The current organization to act on'
Settings.define 'current.repo', description: 'The current repo to act on'
Settings.read '.ghcli.conf'
Settings.resolve!

module Ghcli
	class State
		attr_reader :org
		attr_reader :repo
		attr_reader :current_user
		attr_reader :client
		attr_accessor :issue_offset

		def initialize(term)
			@term = term
			@issue_offset = 0

			Octokit.middleware = Faraday::RackBuilder.new do |builder|
				builder.use Faraday::HttpCache
				builder.use Octokit::Response::RaiseError
				builder.adapter Faraday.default_adapter
			end

			begin
				fail :no_access_token if Settings.access_token.nil?
				@client = Octokit::Client.new access_token: Settings.access_token
			rescue
				window = Ghcli::Terminal::AskLoginWindow.exec @term, self
				@client = Octokit::Client.new login: window.username, password: window.password
				token = @client.create_authorization scopes: [:user], note: 'GHCLI'
				Settings.access_token = token[:token]
			end

			if @client.user_authenticated?
				@current_user = @client.user.login
				Ghcli::Terminal::AskCurrentWindow.exec @term, self if org.nil? || repo.nil?
			else
				puts "Unable to authenticate"
				exit
			end
		end

		def save!
			Settings.save! '.ghcli.conf'
		end

		def org
			Settings[:current][:org]
		end
		def org=(org)
			Settings[:current][:org] = org
			@issues = nil
		end
		def repo
			Settings[:current][:repo]
		end
		def repo=(repo)
			Settings[:current][:repo] = repo
			@issues = nil
		end
		def repository_str
			"#{org}/#{repo}"
		end

		def issues
			@issues ||= (@client.list_issues(repository_str) + @client.list_issues(repository_str, page: 2)).map { |i| Ghcli::Github::Issue.new self, i }
		end

		def reset_issues!
			@issues = nil
		end

		def issue(id)
			@issues.find { |i| i.issue[:number] == id } || Ghcli::Github::Issue.new(self, id)
		end

		private

		def repository
			@client.repository owner: org, name: repo
		end
	end
end
