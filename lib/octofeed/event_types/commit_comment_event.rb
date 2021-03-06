module OctoFeed
  class CommitCommentEvent < OctoFeed::Event

    def initialize(json, opts={})
      super json, opts

      @object = {
        :id => json['payload']['comment']['id'],
        :commit => json['payload']['comment']['commit_id'],
        :body => CGI::escapeHTML(json['payload']['comment']['body']),
        :url => json['payload']['comment']['html_url']
      }
    end

    def url
      %(<a class="repo" href="https://github.com/#{@repo[:name]}/commit/#{@object[:commit]}">commit #{@object[:commit][0..9]}</a>)
    end

    def print
      message = truncate @object[:body]
      message = md_renderer(message, @repo[:name])

      super({
        :title => "#{gh_user_link @actor[:username]} commented on #{gh_link @repo[:name]}",
        :body => %(<span>Comment in #{gh_commit_comment_link @repo[:name], @object[:id], @object[:commit]}</span> <blockquote title="#{@object[:body]}">#{message}</blockquote>)
      })
    end

    def set_repo_group
      link = gh_link("#{@repo[:name]}/commit/#{@object[:commit]}", :label => "commit #{@object[:commit][0..9]}")

      super({
        :id => "#{@repo[:name]}-commitcomment-#{@object[:commit]}",
        :title => "#{gh_user_repo_link @repo[:name]} #{extra(link)}"
      })
    end

  end
end
