class Authentication
  attr_accessor :user

  def initialize(email, password)
    @user = User.find_by(email: email)
    @password = password
  end

  def successful?
    user_exist? && password_is_valid?
  end

  private
  def user_exist?
    !@user.nil?
  end

  def password_is_valid?
    return false unless user_exist?
    @user.password_hash == BCrypt::Engine.hash_secret(@password, @user.password_salt)
  end
end
