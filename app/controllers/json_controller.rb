class JsonController < ApplicationController
    protect_from_forgery except: [:json_quotes, :json_quote_creation, :json_quote_removal, :json_tag_creation, :json_sign_out]

    def json_demo
      @user = CreateGuest.create

      if @user.save
        # Initiate a session
        respond_to do |format|
          format.json { render json: { user_token: @user.token, user_is_guest: true } }
        end
      end
    end 

    def json_sign_in
      authentication = Authentication.new(params[:email], params[:password])
      
      # create_cookies_for(authentication.user)
      respond_to do |format|
        if authentication.successful?
          format.json { render json: { user_email: authentication.user.email, user_token: authentication.user.token, user_id: authentication.user.id } }
        else
          format.json { render json: { notice: "Sorry, this combo didn't check out."} }
        end
      end
    end

    def json_sign_out
      # Receiving the token as a param in the request
      if request.headers['Authorization'].include? "Bearer"
        pattern = /^Bearer /
        header  = request.headers['Authorization']
        token = header.gsub(pattern, '') if header && header.match(pattern)
      end

      @user = User.find_by(token: token)

      respond_to do |format|
        format.json {
          if @user
            render json: { success: true }
          else
            render json: { success: false }, status: :unauthorized
          end
        }
      end
    end

    def json_quotes
      token = ""
      # Receiving the token as a param in the request
      if request.headers['Authorization'].include? "Bearer"
        pattern = /^Bearer /
        header  = request.headers['Authorization']
        token = header.gsub(pattern, '') if header && header.match(pattern)
      end

      @user = User.find_by(token: token)
      @sources = Source.where(id: @user.board.quotes.pluck(:source_id))
      sources_with_count = @sources.map do |source|
        source.as_json.merge(count: @user.board.source_count(source))
      end

      respond_to do |format|
        format.json {
          render json: { quotes: @user.board.quotes, sources: sources_with_count }
        }
      end
      
    end

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

    def json_quote_removal
      token = ""
      # Receiving the token as a param in the request
      if request.headers['Authorization'].include? "Bearer"
        pattern = /^Bearer /
        header  = request.headers['Authorization']
        token = header.gsub(pattern, '') if header && header.match(pattern)
      end

      @user = User.find_by(token: token)

      respond_to do |format|
        format.json {
          if @user
            quotes_to_remove = @user.board.quotes.where(id: params[:quote_ids])
            removed_ids = quotes_to_remove.pluck(:id)
            quotes_to_remove.destroy_all
            render json: { success: true, removed_ids: removed_ids }
          else
            render json: { success: false }, status: :unauthorized
          end
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
  