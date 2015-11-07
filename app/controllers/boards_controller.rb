class BoardsController < ApplicationController
  before_filter :record_user_activity

  def demo
    # Log in demo user
    @user = User.find_by_email("board@ettui.com")
    @quotes = @user.boards.first.quotes.all
    @search = Search.new(params[:search])

    @unread = Quote.since(current_user.last_active_at)

    respond_to do |format|
      if @user
        format.html
      else
        format.html { redirect_to root_url }
      end
    end
  end

  def create
    @board = Board.new(:name => board_params[:name])

    if @board.save
      current_user.boards << @board # Connect the new board to the current users boards.
      redirect_to @board
    end
  end

private
  def create_cookies_for user
    if user
      cookies[:user_id] = { :value => user.id, :expires => 3.months.from_now }
      if user.new_user
        redirect_to intro_path
      else
        redirect_to user.boards.first
      end
    else
      redirect_to root_url, :notice => "Failed to authenticate!"
    end
  end
  # Using a private method to encapsulate the permissible parameters is
  # just a good pattern since you'll be able to reuse the same permit
  # list between create and update. Also, you can specialize this method
  # with per-user checking of permissible attributes.
  # def board_params
  #   params.require(:board).permit(:id, :name, :description)
  # end
end
