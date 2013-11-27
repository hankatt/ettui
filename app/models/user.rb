class User < ActiveRecord::Base

	# Establish relation to quotes
	has_and_belongs_to_many :boards, :join_table => :subscriptions

	attr_accessor :password, :password_confirmation
	
	# Encrypt password before saving it to the database
	before_save :encrypt_password

	# If save was successful, set a token for the user
	after_save :initialize_user

	
	# Form validations
	validates_uniqueness_of :email, :unless => :uid
	validates_presence_of :email, :password, :password_confirmation, :unless => :provider
	validates_confirmation_of :password, :unless => :provider

	# Encrypts and stores the provided password
	def encrypt_password
		if password.present?
			self.password_salt = BCrypt::Engine.generate_salt
			self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
		end
	end

	# Create method for users signing in using an Omniauth service (i.e. Twitter)
	def self.create_with_omniauth(auth)

		# Create the new user
  		@user = User.new({ :provider => auth["provider"], :uid => auth["uid"], :name => auth["info"]["name"], :new_user => true })
	    
	    # Create a board and associate it to the new user
	    @board = Board.create!(name: "My board")
	    @user.boards << @board

	    # Saving the user to database
	    @user.save!

	    # Update the new board with the new user id
	    @board.update(user_id: @user.id)

	    # Return user
	    @user
	end

	# Authenticates the user
	def self.authenticate(email, password)
		user = find_by_email(email)
		if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
			user
		else
			nil
		end
	end

	def current_user
		find(session[:user_id])
	end

	# Generates and sets a token for the new user
	private
	def initialize_user
		# Give the new user a token
		if self.token.nil?
			token = SecureRandom.hex(13)

			# Make sure token is unique
			while User.find_by_token(token)
				token = SecureRandom.hex(13)
			end

			# We now have a token, so lets set it
			self.update(token: token)
		end
	end
end
