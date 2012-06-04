module OctoFeed
  class FollowEvent < OctoFeed::Event

    def initialize(json, session=nil)
      super json
      @session = session

      @object = {
        :id => json['payload']['target']['id'],
        :username => json['payload']['target']['login'],
        :avatar => json['payload']['target']['avatar_url'],
        :repos => json['payload']['target']['public_repos'],
        :followers => json['payload']['target']['followers']
      }
    end

    def print
      if @session && @session[:user][:username] == @object[:username]
        time_ago = time_ago Time.parse(@created_at)
        img_title = "#{@actor[:username]} started following you #{time_ago}"
        img = %(<img width="30" height="30" src="#{actor[:avatar]}" title="#{img_title}">)

        hash = {
          :title => '',
          :body => gh_link(@actor[:username], :label => img),
          :time_ago => ''
        }
      else
        hash = { :title => "#{gh_user_link @actor[:username]} started following #{gh_link @object[:username]}" }
      end

      super hash
    end

    def set_user_group
      if @session && @session[:user][:username] == @object[:username]
        opts = {
          :id => "being-followed",
          :title => "New followers",
          :icon => @object[:avatar],
          :name => @object[:username]
        }
      end

      super opts || {}
    end

  end
end
