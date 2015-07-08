class BookmarkletController < ApplicationController
  # The user needs their bookmarklet.
  def show
    @user = User.find(cookies[:user_id]) unless cookies[:user_id].nil?
    respond_to do |format|
        if @user
            format.html
        else
            format.html { redirect_to root_url }
        end
    end
  end
end
