class CreateGuest
  def self.create
    user = User.new

    user.guest = true
    user.new_user = true
    user.name = "Demo User"
    user.twitter_image_url = "https://randomuser.me/api/portraits/med/women/84.jpg"

    user
  end
end
