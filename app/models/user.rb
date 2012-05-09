class User < ActiveRecord::Base

	require 'base64'

	attr_accessible :email, :password, :password_confirmation, :token
	attr_accessor :password, :password_confirmation
	
	validates_uniqueness_of :email
	validates_presence_of :password
	validates_presence_of :email
	validates_confirmation_of :password


	before_save :encrypt_password
	after_save :set_token


	def encrypt_password
		if password.present?
			self.password_salt = BCrypt::Engine.generate_salt
			self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
		end
	end

	private
	def set_token
		if self.token.nil?
			token = Base64::encode64(self.id.to_s)
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
end
