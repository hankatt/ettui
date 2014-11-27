class UsersController < ApplicationController

  def intro
      @user = User.find(session[:user_id]) unless session[:user_id].nil?
      record_user_activity

      respond_to do |format|
          if @user && @user.new_user
              format.html # intro.html.erb
              flash[:notice] = "Logged in."
          elsif @user && !@user.new_user
              format.html { redirect_to boards_path }
          else
              format.html { redirect_to root_url }
          end
      end
  end

  def bookmarklet
    @user = User.find(session[:user_id]) unless session[:user_id].nil?

    respond_to do |format|
        if @user
            format.html # bookmarklet.html.erb
        else
            format.html { redirect_to root_url }
        end
    end
  end

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
        format.html { redirect_to intro_path, :notice => "You successfully signed up." }
      else
        format.html { render action: "new", :notice => "A user with that email address already exists. If it's you, please try the login page." }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def done
    @user = User.find(session[:user_id])

    respond_to do |format|
      if @user.update_attributes!(:new_user => false)
        format.html { redirect_to boards_path }
      else
        format.html { redirect_to login_path }
      end
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

  def update_all_user_omniauth_data

    # Update all users before this was implemented
    User.where(["updated_at < ?", "2014-10-31 12:00:00"]).each do |user|
      if !user.uid.blank?

        # Fetch user's Twitter data
        auth = Twitter.user(user.uid.to_i)

        # Define params we want to update
        user_params = {
          :name => auth.name,
          :twitter_image_url => auth.profile_image_url,
          :twitter_description => auth.description
        }

        # Update user attributes
        user.update_attributes(user_params)
      end
    end

    respond_to do |format|
        format.html { redirect_to boards_path, notice: 'User was successfully updated.' }
    end
  end

  def show

        @user = User.find(params[:id])
        @board = @user.boards.first
        @quotes = @board.complex_find_by(params)

        # Get a list of all sources for this users quotes
        @sources = Source.where(:id => @board.quotes.pluck(:source_id))

        # Define tag count specifically for this board
        @board.owned_tags.each do |tag|
            tag.set_context_count(@board)
        end

        respond_to do |format|
            format.html # show.html.erb
            format.js # show.js.erb
            format.json { render json: @quotes }
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

  def index
    if current_user
      @user = current_user
    end
    
    respond_to do |format|
      if cookies[:user_id] || session[:user_id]
        format.html { redirect_to boards_path }
      else
        format.html
      end
    end
  end

  private
  # Using a private method to encapsulate the permissible parameters is
  # just a good pattern since you'll be able to reuse the same permit
  # list between create and update. Also, you can specialize this method
  # with per-user checking of permissible attributes.
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :token, :uid, :provider, :name, :new_user, :twitter_image_url, :twitter_description)
  end

end
