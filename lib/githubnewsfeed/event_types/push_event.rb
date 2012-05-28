module GitHubNewsFeed
  class PushEvent < GitHubNewsFeed::Event

    def initialize(json)
      super json

      commits = []
      json['payload']['commits'].each do |commit|
        commits << {
          :message => commit['message'],
          :sha => commit['sha'],
          :author => commit['author']['name']
        }
      end

      @object = {
        :ref => json['payload']['ref'],
        :commits => commits
      }
    end

    def print
      commits_content = ''
      @object[:commits].reverse.each do |commit|
        commits_content << "<li>#{gh_sha_link @repo[:name], commit[:sha]} #{commit[:message].split(/\n\n/).first}</li>"
      end

      "#{gh_link @actor[:username]}
      pushed to
      #{@object[:ref].gsub('refs/heads/', '')}
      at #{gh_link @repo[:name]}
      #{time_ago_in_words Time.parse(@created_at)} ago
      <ul>
        #{commits_content}
      </ul>"
    end

  end
end