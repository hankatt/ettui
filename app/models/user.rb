class User < ActiveRecord::Base

  # Establish relation to quotes
  has_and_belongs_to_many :boards, join_table: :subscriptions
  before_destroy :destroy_boards

  attr_accessor :password, :password_confirmation

  # Encrypt password before saving it to the database
  before_save :encrypt_password

  # If save was successful, set a token for the user
  after_save :initialize_user

  has_many :quotes, dependent: :destroy

  # Form validations
  validates_uniqueness_of :email, unless: :provider_or_guest?
  validates_presence_of :email, :password, :password_confirmation, unless: :provider?, on: :create_or_save, unless: :guest?
  validates_presence_of :email, :password, :password_confirmation, unless: :provider?, on: :update, allow_blank: true
  validates_confirmation_of :password, unless: :provider_or_guest?

  def board
    boards.first
  end

  def unique_tags
    board.tags.distinct
  end

  def quote_count
    board.quotes.count
  end

  def source_count
    board.quotes.pluck(:source_id).distinct.count
  end

  def tag_count
    board.tags.distinct.count
  end

  def name_or_email
    name || email
  end

  def update_password(password)
    self.password = password
    self.password_reset_token = nil
    self.password_reset_sent_at = nil
  end

  def create_password_reset_token
    self.password_reset_token = SecureRandom.hex(13)
    self.password_reset_sent_at = Time.zone.now
    save!
  end

  def send_password_reset
    create_password_reset_token
    UserMailer.password_reset(self).deliver_now
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

  # Encrypts and stores the provided password
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def provider_or_guest?
    provider? || guest?
  end
end
