class UserMailer
  def self.password_reset(user)
    client = Postmark::ApiClient.new(ENV["POSTMARK_API_TOKEN"])
    client.deliver_with_template(
      from:           "services@ettui.com",
      to:             user.email,
      template_id:    45084366,
      template_model: {
        "product_name"          => "ettui.com",
        "name"                  => user.name || user.email,
        "action_url"            => "https://www.ettui.com/reset/#{user.password_reset_token}",
        "sender_name"           => "Henrik",
        "support_url"           => "https://www.ettui.com/legal/support"
      }
    )
  end
end
