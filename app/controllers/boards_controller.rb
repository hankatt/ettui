class BoardsController < ApplicationController

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
    @board = Board.find(board_params[:id])

    @search = Search.new(params[:search])

    @quotes = @board.quotes.reverse_order
    @unread = []

    # Get a list of all sources for this users quotes
    @sources = Source.where(:id => @board.quotes.pluck(:source_id))

    set_titles("", "Your quotes")

    respond_to do |format|
      format.html # show.html.erb
      # format.js # show.js.erb
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

  def update
    @board = Board.find(params[:id])

    respond_to do |format|
      if @board.update_attributes(board_params)
        format.js # update.js.erb
      end
    end
  end

private
  # Using a private method to encapsulate the permissible parameters is
  # just a good pattern since you'll be able to reuse the same permit
  # list between create and update. Also, you can specialize this method
  # with per-user checking of permissible attributes.
  def board_params
    params.require(:board).permit(:name, :description)
  end
end
