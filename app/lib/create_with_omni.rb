class CreateWithOmni
  def create(auth)
    # Create the new user
    @user = User.new({
      provider: auth["provider"],
      uid: auth["uid"],
      name: auth["info"]["name"],
      twitter_image_url: auth["info"]["image"],
      twitter_description: auth["info"]["description"],
      new_user: true
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
end
