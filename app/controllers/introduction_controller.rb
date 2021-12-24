class IntroductionController < ApplicationController
  before_action :authorize

  def start
    current_user.touch :last_active_at
  end

  def trying_it

  end

  def finish
    if current_user.update(new_user: false)
      redirect_to board_path(current_user.board)
    else
      # could not update new user -> should probably let user
      # know and redirect
    end
  end
end
