class QuotesController < ApplicationController
  before_action :authorize, except: :show 

  def show
    @quote = Quote.find(params[:id])
    @board = @quote.boards.first
    @user = @board.users.first
    @search = Search.new
  end

  def destroy
    @quote = Quote.find(params[:id])

    if @quote.destroy
      redirect_to board_path(current_user.board)
    end
  end
end
