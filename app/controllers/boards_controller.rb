class BoardsController < ApplicationController

    def index
        if current_user
            @user = current_user
        end
    end

    def show
        if cookies[:user_id]
            @user = User.find(cookies[:user_id])
        else
            redirect_to root_url
        end

        @board = Board.find(params[:id])

        # complex_find_by(parameters, only new quotes (true/false), when user was last seen)
        if params && params[:unread] == "true"
            @quotes = @board.unread(@user.last_active_at)
            record_user_activity
            @nothingUnread = true
        else
            @unread = @board.unread(@user.last_active_at)
            @quotes = @board.complex_find_by(params)
        end

        # Get a list of all sources for this users quotes
        @sources = Source.where(:id => @board.quotes.pluck(:source_id))

        # Define tag count specifically for this board
        @board.owned_tags.each do |tag|
            tag.update_tag_count_on(@board)
        end

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