require 'pp'

module Ruboty
  module Github
    module Actions
      class ShowUndeployedPullRequests < Base
        def call
          case
          when !has_access_token?
            require_access_token
          else
            repos.each do |repo|
              show(repo)
            end
          end
        rescue Octokit::Unauthorized
          message.reply("Failed in authentication (401)")
        rescue Octokit::NotFound
          message.reply("Could not find that issue")
        rescue => exception
          raise exception
          message.reply("Failed by #{exception.class}")
        end

        private

        def show(repo)
          pull_requests = merge_pull_requests(repo)
          if pull_requests.empty?
            message.reply "#{repo} には未リリースのPRはないようだぞ！"
          else
            message.reply "#{repo} には以下の未リリースPRがあるぞ！"
            r = Regexp.union(
              /\AMerge pull request (?<number>\#\d+).*\n\n(?<title>.+)/,
              /\A(?<title>.+) \((?<number>#\d+)\)/)
            pull_requests.each do |text|
              m = text.match(r) { |t| "#{t[:number]} #{t[:title]} https://github.com/#{repo}/pull/#{t[:number].gsub('#', '')}" }
              message.reply m
            end
          end
        end

        def merge_pull_requests(repo)
          commits(repo)[:commits].map {|commit|
            commit[:commit][:message]
          }.grep(/(\A.+ \(#\d+\)|\AMerge pull request)/)
        end

        def commits(repo)
          client.compare(repo, latest_deploy, 'develop')
        end

        def latest_deploy
          'release'
        end

        def repos
          message[:repo].split(',')
        end
      end
    end
  end
end
