module HeaderHelper
	def left_header_element
		if params[:controller].eql?("users")
  			link_to @left_title, :back, :class => "quotes-title indent"
  		else
  			content_tag :h4, :class => "quotes-title indent" do
  				@left_title
  			end
  		end
	end
end
