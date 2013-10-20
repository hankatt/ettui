class BoardsController < ApplicationController

    def index

    end

    def show
        if session[:user_id]
            @user = User.find(session[:user_id])
        end

        @board = Board.find(params[:id])
        puts("params: " << params.to_s)
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
            redirect_to board_path(@board.id)
        end
    end

end