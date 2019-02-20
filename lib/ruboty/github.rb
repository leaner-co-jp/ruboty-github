require "active_support/core_ext/string/strip"
require "octokit"

require "ruboty"
require "ruboty/github/actions/base"
require "ruboty/github/actions/close_issue"
require "ruboty/github/actions/create_issue"
require "ruboty/github/actions/create_pull_request"
require "ruboty/github/actions/show_pull_request"
require "ruboty/github/actions/show_undeployed_pull_requests"
require "ruboty/github/actions/merge_pull_request"
require "ruboty/github/actions/remember"
require "ruboty/github/actions/create_branch"
require "ruboty/github/actions/push_branch"
require "ruboty/github/actions/deploy"
require "ruboty/github/version"
require "ruboty/handlers/github"
