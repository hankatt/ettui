class User < ActiveRecord::Base

	# Establish relation to quotes
	has_and_belongs_to_many :boards, :join_table => :subscriptions
	before_destroy :destroy_boards

	attr_accessor :password, :password_confirmation

	# Encrypt password before saving it to the database
	before_save :encrypt_password

	# If save was successful, set a token for the user
	after_save :initialize_user

	has_many :quotes, dependent: :destroy

	# Form validations
	validates_uniqueness_of :email, unless: :provider_or_guest?
	validates_presence_of :email, :password, :password_confirmation, :unless => :provider, on: :create, unless: :guest?
	validates_presence_of :email, :password, :password_confirmation, :unless => :provider, on: :update, allow_blank: true
	validates_confirmation_of :password, unless: :provider_or_guest?

	def provider_or_guest?
		provider? || guest?
	end

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
			@user = User.new({
				:provider => auth["provider"],
				:uid => auth["uid"],
				:name => auth["info"]["name"],
				:twitter_image_url => auth["info"]["image"],
				:twitter_description => auth["info"]["description"],
				:new_user => true
			})

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

	def self.new_guest_user
		user = User.new

		user.guest = true
    user.new_user = true
    user.name = "Kim 'Demo' Chi"
    user.twitter_image_url = "https://randomuser.me/api/portraits/med/women/84.jpg"

    user
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

	def quote_count
		boards.first.quotes.count
	end

	def source_count
		boards.first.quotes.pluck(:source_id).uniq.count
	end

	def tag_count
		boards.first.tags.uniq.count
	end

	def name_or_email
		name || email
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

      # Initiate a board for the user
      self.boards << Board.create({ user_id: self.id, name: "My board" })
		end
	end

	def destroy_boards
		boards.each do |board|
			board.destroy unless board.has_subscribers?
		end
	end
end
