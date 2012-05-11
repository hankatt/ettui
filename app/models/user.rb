class User < ActiveRecord::Base

	attr_accessible :email, :password, :password_confirmation, :token
	attr_accessor :password, :password_confirmation
	
	before_save :encrypt_password
	after_save :set_token

	has_many :quotes

	def encrypt_password
		if password.present?
			self.password_salt = BCrypt::Engine.generate_salt
			self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
		end
	end

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
	
	def self.authenticate(email, password)
		user = find_by_email(email)
		if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
			user
		else
			nil
		end
	end

	def self.create_with_omniauth(auth)
  		create! do |user|
	   		user.provider = auth["provider"]
	    	user.uid = auth["uid"]
	    	user.name = auth["info"]["name"]
  		end
	end
end
