Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'VVeSODAiQmCGaqcmbJBZjg', '3gaqnVLxNybMS9EdtVbJRtfdg2acyTKamvotNQXnHGU',
  	{
      :secure_image_url => 'true',
      :image_size => 'original'
    }
end
