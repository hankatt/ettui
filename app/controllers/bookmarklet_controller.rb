class BookmarkletController < ApplicationController
    protect_from_forgery except: :show

    def show
        @bookmarklet_server_host = request.host_with_port
    end

end
