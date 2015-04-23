module Ruboty
  module Handlers
    class Github < Base
      env :GITHUB_HOST, "Pass GitHub Host if needed (e.g. github.example.com)", optional: true

      on(
        /create issue "(?<title>.+)" on (?<repo>.+)(?:\n(?<description>[\s\S]+))?\z/,
        name: "create_issue",
        description: "Create a new issue",
      )

      on(
        /remember my github token (?<token>.+)\z/,
        name: "remember",
        description: "Remember sender's GitHub access token",
      )

      on(
        /close issue (?<repo>.+)#(?<number>\d+)\z/,
        name: "close_issue",
        description: "Close an issue",
      )

      on(
        /pull request "(?<title>.+)" from (?<from>.+) to (?<to>.+)(?:\n(?<description>[\s\S]+))?\z/,
        name: "create_pull_request",
        description: "Create a pull request",
      )

      on(
        /merge (?<repo>.+)#(?<number>\d+)\z/,
        name: "merge_pull_request",
        description: "Merge pull request",
      )

      on(
        /create branch "(?<name>.+)" from (?<from>.+)/,
        name: "create_branch",
        description: "Create branch"
      )

      on(
        /prepare (?<name>.+) (?<repo>.+)/,
        name: 'prepare_deploy',
        description: 'prepare deploy branch'
      )

      on(
        %r{https?://github\.com/(?<repo>.*)/pull/(?<number>\d+)},
        name: "show_pull_request",
        description: "show pull request",
        all: true
      )

      def create_issue(message)
        Ruboty::Github::Actions::CreateIssue.new(message).call
      end

      def close_issue(message)
        Ruboty::Github::Actions::CloseIssue.new(message).call
      end

      def remember(message)
        Ruboty::Github::Actions::Remember.new(message).call
      end

      def create_pull_request(message)
        Ruboty::Github::Actions::CreatePullRequest.new(message).call
      end

      def merge_pull_request(message)
        Ruboty::Github::Actions::MergePullRequest.new(message).call
      end

      def create_branch(message)
        Ruboty::Github::Actions::CreateBranch.new(message).call
      end

      def prepare_deploy(message)
        Ruboty::Github::Actions::Deploy.new(message).call
      end

      def show_pull_request(message)
        Ruboty::Github::Actions::ShowPullRequest.new(message).call
      end
    end
  end
end
