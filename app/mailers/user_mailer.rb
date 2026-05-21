class UserMailer
  def self.password_reset(user)
    client = Postmark::ApiClient.new(ENV["POSTMARK_API_TOKEN"])
    client.deliver(
      from:      "services@ettui.com",
      to:        user.email,
      subject:   "Reset your ettúi password",
      text_body: "Hi #{user.name || user.email},\n\n" \
                 "Someone requested a password reset for your ettúi account.\n\n" \
                 "Reset your password here:\nhttps://www.ettui.com/reset/#{user.password_reset_token}\n\n" \
                 "This link expires in 1 hour. If you didn't request this, you can ignore this email.\n\n" \
                 "— Henrik at ettúi"
    )
  end
end
