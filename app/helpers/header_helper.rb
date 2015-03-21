module HeaderHelper
	def left_header_element
		if params[:controller].eql?("users")
  			link_to @left_title, boards_path, :class => "header-title"
  		else
  			content_tag :h4, :class => "header-title" do
  				@left_title
  			end
  		end
	end
end
