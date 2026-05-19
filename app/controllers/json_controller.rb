class JsonController < ApplicationController
    protect_from_forgery except: [:json_quotes, :json_quote_creation, :json_quote_removal, :json_tag_creation, :json_sign_out, :json_demo_account_completion, :json_account_deletion]

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

    def json_account_deletion
      if request.headers['Authorization'].include? "Bearer"
        pattern = /^Bearer /
        header  = request.headers['Authorization']
        token = header.gsub(pattern, '') if header && header.match(pattern)
      end

      @user = User.find_by(token: token)

      respond_to do |format|
        format.json {
          if @user.nil?
            render json: { success: false }, status: :unauthorized
            next
          end

          tag_ids = @user.quotes.joins(:tags).pluck("tags.id").uniq
          @user.destroy
          Tag.where(id: tag_ids).left_joins(:quotes).where(quotes: { id: nil }).destroy_all

          render json: { success: true }
        }
      end
    end

    def json_demo_account_completion
      if request.headers['Authorization'].include? "Bearer"
        pattern = /^Bearer /
        header  = request.headers['Authorization']
        token = header.gsub(pattern, '') if header && header.match(pattern)
      end

      @user = User.find_by(token: token)

      respond_to do |format|
        format.json {
          if @user.nil?
            render json: { success: false }, status: :unauthorized
            next
          end

          if User.exists?(email: params[:email])
            render json: { success: false, error: "Email already taken" }
            next
          end

          if params[:password] != params[:password_confirmation]
            render json: { success: false, error: "Passwords do not match" }
            next
          end

          if @user.update(email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation], guest: false)
            render json: { success: true, user_email: @user.email }
          else
            render json: { success: false }
          end
        }
      end
    end

    # TODO: Broadening this function to also return Bookmarks. (A Quote without a text key)
    # QUESTION FOR CLAUDE: Suggestion for how to refactor it to be less Quotes specific in its name?
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
      quotes_with_tags = @user.board.quotes.includes(:tags).map do |quote|
        quote.as_json.merge(tags: quote.tags)
      end

      respond_to do |format|
        format.json {
          render json: { quotes: quotes_with_tags, sources: sources_with_count }
        }
      end
    end

    # NEW: Bookmark creation introduces a new variant of a Quote.
    #
    # QUESTION FOR CLAUDE: Should I make a new Bookmark model or reuse Quote?
    # A bookmark is a Quote without a Text. It can still contain tags. It still has a source.
    #
    # The function returns the user's tags and a @bookmark.id so the user can append tags to the @bookmark from the UI.


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
  