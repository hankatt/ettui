class JsonController < ApplicationController
    protect_from_forgery except: [:json_quote_creation, :json_tag_creation]

    def json_quote_creation

      token = ""
      # Receiving the token as a param in the request
      if request.headers['Authorization'].include? "Bearer"
        pattern = /^Bearer /
        header  = request.headers['Authorization']
        token = header.gsub(pattern, '') if header && header.match(pattern)
      end

      @user = User.find_by(token: token)
      @quote = QuoteHandler.create_for_user(params, @user.id)
      @tags = nil
      
      respond_to do |format|
        # Successfully saved
        if @quote.save
          @user.board.quotes << @quote
          @tags = @user.unique_tags
        end

        format.json {
            render json: { tags: @tags, quote_id: @quote.id, quote_url: board_path(@quote.boards.first) }
          }
      end
    end
  
    def json_tag_creation

      token = ""
      # Receiving the token as a param in the request
      if request.headers['Authorization'].include? "Bearer"
        pattern = /^Bearer /
        header  = request.headers['Authorization']
        token = header.gsub(pattern, '') if header && header.match(pattern)
      end

      @tag = TagHandler.find_or_initialize(params[:tag])
      @quote = Quote.find(params[:quote_id])

        # Add or remove tag
      if @quote.tags.include?(@tag)
        if @tag.last_instance?
          @tag.destroy
        else
          @quote.tags.delete(@tag)
        end
      else
        @quote.tags << @tag
      end

      # Get all the users unique tags from the users board
      @user = User.find_by(token: token)
      @tags = @user.unique_tags

      # Return a set with tags intersecting the user's tags and the quote's.
      # Mark all these as existing.
      @selected = []
      (@tags & @quote.tags).each do
        |tag| tag.is_existing = true
        @selected << tag
      end
  
      respond_to do |format|
        # Respond with data{…} sent to the function added(…) in the bookmarklet
        format.json {
            render json: { tags: @tags, selected: @selected }
        }
      end
    end
  
    def preview
      if current_user
        @tags = current_user.unique_tags
      else
        redirect_to :root
      end
    end
  end
  