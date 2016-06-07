class UserMailer < ActionMailer::Base

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
  	user_email = user.email
  	user_name = user.name || user.email
  	user_reset_token = user.password_reset_token

  	client = Postmark::ApiClient.new(ENV["POSTMARK_API_TOKEN"])
  	client.deliver_with_template(
      :from           =>  'services@ettui.com',
      :to             =>  user_email,
      :template_id    =>  678341,
      :template_model => { 
        "product_name"  => "ettui.com", 
        "name"          => user_name, 
        "action_url"    => "http://www.ettui.com/reset/#{user_reset_token}", 
        "sender_name"   => "Henrik", 
        "product_address_line1" => "http://www.ettui.com"
  		})
  end
end