class BoardsController < ApplicationController

    def index
        if session[:user_id]
            @user = User.find(session[:user_id])
            redirect_to @user.boards.first
        else
            redirect_to root_url
        end
    end

    def intro
        @user = User.find(session[:user_id]) unless session[:user_id].nil?

        respond_to do |format|
            if @user && @user.new_user
                format.html # show.html.erb
                flash[:notice] = "Logged in."
            elsif @user
                format.html { redirect_to boards_path }
            else
                format.html { redirect_to root_url }
            end
        end
    end

    def show
        if session[:user_id]
            @user = User.find(session[:user_id])
        else
            redirect_to root_url
        end

        @board = Board.find(params[:id])
        @quotes = @board.complex_find_by(params)

        

         # Get a list of all sources for this users quotes
        @sources = Source.where(:id => @board.quotes.pluck(:source_id))

        respond_to do |format|
            format.html # show.html.erb
            format.js # show.js.erb
            format.json { render json: @quotes }
        end
    end

    def create
        @board = Board.new(:name => params[:name])

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