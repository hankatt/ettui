class UserMailer
  def self.password_reset(user)
    client = Postmark::ApiClient.new(Rails.application.credentials.postmark_api_token)
    client.deliver(
      from:     "services@ettui.com",
      to:       user.email,
      subject:  "Reset your ettúi password",
      text_body: "Hi #{user.name || user.email},\n\n" \
                 "Someone requested a password reset for your ettúi account.\n\n" \
                 "Reset your password here:\n#{reset_url(user.password_reset_token)}\n\n" \
                 "This link expires in 1 hour. If you didn't request this, you can ignore this email.\n\n" \
                 "— Henrik at ettúi"
    )
  end

  private

  def self.reset_url(token)
    "https://www.ettui.com/reset/#{token}"
  end
end
