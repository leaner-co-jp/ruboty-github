module Ruboty
  module Github
    module Actions
      class CreateBranch < Base
        def call
          if has_access_token?
            create
          else
            require_access_token
          end
        end

        private

        def create
          message.reply("Created #{branch.html_url}")
        rescue Octokit::Unauthorized
          message.reply("Failed in authentication (401)")
        rescue Octokit::NotFound
          message.reply("Could not find that repository")
        rescue => exception
          message.reply("Failed by #{exception.class} #{exception}")
        end

        def branch
          client.create_ref(repository, ref, sha1)
        end

        def ref
          message[:name]
        end

        def sha1
          client.branch(repository, from_branch).commit.sha
        end

        # e.g. alice/foo:test
        def from
          message[:from]
        end

        # e.g. alice
        def from_user
          from.split("/").first
        end

        # e.g. test
        def from_branch
          from.split(":").last
        end

        # e.g. bob/foo
        def repository
          from.split(":").first
        end
      end
    end
  end
end
