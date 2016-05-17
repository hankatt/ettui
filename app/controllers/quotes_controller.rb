class QuotesController < ApplicationController
  before_action :authorize

  def show
    @quote = Quote.find(params[:id])
    @user = @quote.boards.first.users.first
  end

  def destroy
    @quote = Quote.find(params[:id])

    if @quote.destroy
      redirect_to board_path(current_user.board)
    end
  end
end
