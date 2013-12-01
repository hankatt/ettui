class UsersController < ApplicationController
  # GET /users/new
  # GET /users/new.json
  def new
      @user = User.new

    respond_to do |format|
      if session[:user_id]
        format.html { redirect_to boards_path }
      else
        format.html # new.html.erb
        format.json { render json: @user }
      end
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        # Establish a session
        session[:user_id] = @user.id

        # Initiate a board for the user
        @user.boards << Board.create({ user_id: @user.id, name: "My board" })

        # What happens after the save is complete
        format.html { redirect_to boards_intro_path, :notice => "You successfully signed up." }
      else
        format.html { render action: "new", :notice => "A user with that email address already exists. If it's you, please try the login page." }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def done
    @user = User.find(session[:user_id])

    if @user.update_attributes!(:new_user => false)
      flash[:partial] = "welcome"
      redirect_to boards_path
    else
      redirect_to login_path
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to signup_path }
      format.json { head :no_content }
    end
  end

  private
  # Using a private method to encapsulate the permissible parameters is
  # just a good pattern since you'll be able to reuse the same permit
  # list between create and update. Also, you can specialize this method
  # with per-user checking of permissible attributes.
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :new_user)
  end

end
