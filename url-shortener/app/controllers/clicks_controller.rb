class ClicksController < ApplicationController

    def track
        user_agent = request.headers["user-agent"]
        link = Link.find_by(url_hash: get_hash)
        if link
            click = Click.new(link: link, user_agent: user_agent)
            click.save!
            redirect_to link.url, allow_other_host: true
        else 
            redirect_to root_path, alert: "Link not found."
        end
    end

    def get_hash
        hash = params.require(:hash)
        puts hash 
        hash
    end
end