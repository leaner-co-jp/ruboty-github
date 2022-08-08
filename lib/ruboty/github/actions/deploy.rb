module Ruboty
  module Github
    module Actions
      class Deploy < Base
        def call
          return require_access_token unless has_access_token?

          repositories.each { |h| create_release_pr(h['repository'], h['base'], h['head']) }
        rescue Octokit::UnprocessableEntity => e
          raise e unless /Reference already exists/.match?(e.message)
          message.reply("Oops! A branch named '#{name}_master' already exists.")
        rescue Octokit::Unauthorized
          message.reply("Failed in authentication (401)")
        rescue Octokit::NotFound
          message.reply("Could not find that repository")
        rescue => exception
          message.reply("Failed by #{exception.class} #{exception}\n#{exception.backtrace}")
        end

        private

        attr_reader :prefix

        def create_release_pr(repository, base, head)
          pull_requests = merge_pull_requests(repository, base, head)

          if pull_requests.empty?
            message.reply("#{repository} にはリリースが必要な差分はないようだな！")
          else
            # DEBUG
            puts "create pr #{repository} #{base}...#{head}"
            puts "title: #{title(base)}"
            puts description(pull_requests)
            pr = client.create_pull_request(repository, base, head, title(base), description(pull_requests))
            message.reply("#{repository} のPRを #{pr.html_url} で作ったぞ！")
          end
        end

        def title(base)
          "#{base == 'release' ? '本番反映' : 'ステージング反映'} #{Time.now.strftime('%Y-%m-%d')}"
        end

        def description(pull_requests)
          r = Regexp.union(
            /\AMerge pull request (?<number>\#\d+).*\n\n(?<title>.+)/,
            /\A(?<title>.+) \((?<number>#\d+)\)/)
          r2 = /\AMerge pull request (?<number>\#\d+) from .*\/dependabot\/(?<title>.+)\z/
          pull_requests.map do |text|
            text.match(r) { |t| "#{t[:number]} #{t[:title]}" } ||
              text.match(r2) { |t| "#{t[:number]} Bump #{t[:title]}" } ||
              text
          end.join("\n")
        end

        def merge_pull_requests(repo, base, head)
          commits(repo, base, head)[:commits].map {|commit|
            commit[:commit][:message]
          }.grep(/(\A.+ \(#\d+\)|\AMerge pull request)/)
        end

        def commits(repo, base, head)
          client.compare(repo, base, head)
        end

        # e.g. team1/repo1:base1...head1,team2/repo2:base2...head2
        def repositories
          message[:repos].split(',').map { |repo| repo.match(/(?<repository>.+):(?<base>.+)\.\.\.(?<head>.+)/).named_captures }
        end
      end
    end
  end
end
