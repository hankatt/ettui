class BoardsController < ApplicationController

  def demo
    # Log in demo user
    @user = User.find_by_email("board@ettui.com")
    @quotes = @user.boards.first.quotes.all
    @search = Search.new(params[:search])

    respond_to do |format|
      if @user
        format.html
      else
        format.html { redirect_to root_url }
      end
    end
  end

  def index
    if current_user
      @user = current_user
    end

    respond_to do |format|
      if @user
        format.html { redirect_to @user.boards.first }
      else
        format.html { redirect_to root_url }
      end
    end
  end

  def show
    @board = Board.find(params[:id])

    @search = Search.new(params[:search])

    @quotes = @board.quotes.reverse_order
    @unread = []

    # Get a list of all sources for this users quotes
    @sources = Source.where(:id => @board.quotes.pluck(:source_id))

    set_titles("", "Recent quotes.")

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quotes }
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
