class UsersController < ApplicationController
  before_action :authorize, except: [:new, :create, :update, :complete, :demo, :reset_password, :update_password, :send_password_reset, :request_password_reset]

  def new
    @user = User.new

    if current_user
      redirect_to board_path(current_user.board)
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # If we're finalizing a demo user
      if user_params[:guest].eql?("false")
        @user.create_password_reset_token
        redirect_to reset_password_path(@user.password_reset_token)
      else
        redirect_back(fallback_location: root_path, notice: "User details were updated.")
      end
    else
      redirect_back(fallback_location: root_path, notice: "Details could not be updated.")
    end
  end

  def create
    @user = user_params ? User.new(user_params) : User.new_guest

    if @user.save
      # Establish a session
      session[:user_id] = @user.id

      # What happens after the save is complete
      redirect_to introduction_path, notice: "You successfully signed up."
    else
      render action: "new", notice: "A user with that email address already exists. If it's you, please try the login page."
    end
  end

  def demo
    if current_user
      redirect_to board_path(current_user.board), notice: "You can't create a demo user when you are already signed in."
    else
      @user = CreateGuest.create
      if @user.save

        # Initiate a session
        session[:user_id] = @user.id

        # Introduce them to their bookmarklet
        redirect_to introduction_path
      end
    end
  end

  def complete
    if current_user && current_user.guest?
      @user = current_user
      render "complete", notice: "Complete your demo account."
    else
      redirect_to root_path, notice: "You need to be signed in as a demo user to do that."
    end
  end

  def profile

    @section = params[:section] || "settings"

    if current_user && current_user.guest?
      @user = current_user
      redirect_to completion_path, notice: "Complete your demo account to fully use Ettúi."
    elsif current_user
      @user = current_user
      @board = @user.board
      render "profile", notice: nil
    else
      redirect_to root_path, notice: "You need to sign in to view that page."
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to signup_path
  end

  def reset_password
    if params[:password_reset_token]
      @user = User.find_by(password_reset_token: params[:password_reset_token])
    else
      redirect_to request_password_reset_path, :notice => "Your password could not be reset. Please try again."
    end
  end

  def request_password_reset
    if current_user
      @user = current_user
      render :notice => "You are about to request a new password for #{@user.name || @user.email}"
    end
  end

  def send_password_reset
    @user = User.find_by(email: params[:email])
    if @user
      @user.send_password_reset
      redirect_to login_path, :notice => "A link where you can reset your password has been sent to your mail."
    else
      redirect_to request_password_reset_path, :notice => "Your password could not be reset. Please try again."
    end
  end

  def update_password
    @user = User.find(params[:id])

    if (@user.password_reset_sent_at - 1.hour.ago) > 0
      @user.update_password(params[:password])

      if @user.save
        redirect_to login_path, :notice => "Your password is updated."
      end
    else
      redirect_to request_password_reset_path, :notice => "Your opportunity to reset your password has expired. Please try again."
    end
  end

  private
  # Using a private method to encapsulate the permissible parameters is
  # just a good pattern since you'll be able to reuse the same permit
  # list between create and update. Also, you can specialize this method
  # with per-user checking of permissible attributes.
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :token, :uid, :provider, :name, :new_user,
                                 :twitter_image_url, :twitter_description, :guest)
  end

end
