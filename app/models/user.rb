class User < ActiveRecord::Base

	# Establish relation to quotes
	has_many :quotes

	attr_accessor :password, :password_confirmation
	
	# Encrypt password before saving it to the database
	before_save :encrypt_password

	# If save was successful, set a token for the user
	after_save :set_token

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

	# Generates and sets a token for the new user
	private
	def set_token
		if self.token.nil?
			token = SecureRandom.hex(13)

			# Make sure token is unique
			while User.find_by_token(token)
				token = SecureRandom.hex(13)
			end

			# We now have a token, so lets set it
			self.update_attributes(:token => token)
		end
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

	# Create method for users signing in using an Omniauth service (i.e. Twitter)
	def self.create_with_omniauth(auth)
  		create! do |user|
	   		user.provider = auth["provider"]
	    	user.uid = auth["uid"]
	    	user.name = auth["info"]["name"]
  		end
	end
end
