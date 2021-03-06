module OctoFeed
  class GollumEvent < OctoFeed::Event

    def initialize(json, opts={})
      super json, opts

      pages = []
      json['payload']['pages'].each do |page|
        pages << {
          :name => page['page_name'],
          :action => page['action'],
          :url => page['html_url']
        }
      end

      @object = {
        :pages => pages
      }
    end

    def print
      pages_content = ''
      @object[:pages].each do |page|
        pages_content << %(<li>#{page[:action]} <a href="#{page[:url]}">#{page[:name]}</a></li>)
      end

      super({
        :title => "#{gh_user_link @actor[:username]} edited the #{gh_link @repo[:name]} wiki",
        :body => "<ul>#{pages_content}</ul>"
      })
    end

  end
end
