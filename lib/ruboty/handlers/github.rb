module Ruboty
  module Handlers
    class Github < Base
      ISSUE_PATTERN = %r<(?:https?://[^/]+/)?(?<repo>.+)(?:#|/pull/|/issues/)(?<number>\d+) ?>

      env :GITHUB_BASE_URL, "Pass GitHub URL if needed (e.g. https://github.example.com)", optional: true

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
        /close(?: issue)? #{ISSUE_PATTERN}\z/,
        name: "close_issue",
        description: "Close an issue",
      )

      on(
        /pull request "(?<title>.+)" from (?<from>.+) to (?<to>.+)(?:\n(?<description>[\s\S]+))?\z/,
        name: "create_pull_request",
        description: "Create a pull request",
      )

      on(
        /merge #{ISSUE_PATTERN}\z/,
        name: "merge_pull_request",
        description: "Merge pull request",
      )

      on(
        /search issues (?<query>.+)/,
        name: "search_issues",
        description: "Search issues",
      )

      on(
        /create branch (?<to_branch>.+) from (?<from>.+)\z/,
        name: "create_branch",
        description: "Create a branch",
      )

      on(
        /push branch (?<repo>\S+) (?<name>.+) from (?<from>.+)/,
        name: "push_branch",
        description: "Push branch"
      )

      on(
        /push force branch (?<repo>\S+) (?<name>.+) from (?<from>.+)/,
        name: "push_force_branch",
        description: "Push force branch"
      )

      on(
        /release (?<repos>\S+)/,
        name: 'prepare_release',
        description: 'prepare production release pull requests'
      )

      on(
        /show undeployed (?<repo>.*)/,
        name: 'show_undeployed_pull_requests',
        description: 'show undeployed pull requests'
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

      def search_issues(message)
        Ruboty::Github::Actions::SearchIssues.new(message).call
      end

      def create_branch(message)
        Ruboty::Github::Actions::CreateBranch.new(message).call
      end

      def push_branch(message)
        Ruboty::Github::Actions::PushBranch.new(message).call
      end

      def push_force_branch(message)
        Ruboty::Github::Actions::PushBranch.new(message, force: true).call
      end

      def prepare_release(message)
        Ruboty::Github::Actions::Deploy.new(message).call
      end

      def show_pull_request(message)
        Ruboty::Github::Actions::ShowPullRequest.new(message).call
      end

      def show_undeployed_pull_requests(message)
        Ruboty::Github::Actions::ShowUndeployedPullRequests.new(message).call
      end
    end
  end
end
