class UsersController < ApplicationController
  before_action :authorize, except: [:new, :create, :demo]

  def new
    @user = User.new

    if current_user
      redirect_to board_path(current_user.board)
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = user_params ? User.new(user_params) : User.new_guest

    if @user.save
      # Establish a session
      session[:user_id] = @user.id

      # What happens after the save is complete
      redirect_to introduction_start_path, notice: "You successfully signed up."
    else
      render action: "new", notice: "A user with that email address already exists. If it's you, please try the login page."
    end
  end

  def demo
    redirect_to root_path if current_user
    @user = CreateGuest.create

    if @user.new_user
      if @user.save
        # Establish a session
        session[:user_id] = @user.id

        # What happens after the save is complete
        redirect_to introduction_start_path, notice: "You successfully signed up."
      end
    else
      redirect_to board_quotes(@user.board)
    end
  end

  def show
    @user = User.find(params[:id])
    @board = @user.board

    @left_title = "« Back to board"
    @quotes_container_title = "Settings"
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to signup_path
  end

  private
  # Using a private method to encapsulate the permissible parameters is
  # just a good pattern since you'll be able to reuse the same permit
  # list between create and update. Also, you can specialize this method
  # with per-user checking of permissible attributes.
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :token, :uid, :provider, :name, :new_user,
                                 :twitter_image_url, :twitter_description)
  end

end
