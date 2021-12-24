class JsonpController < ApplicationController
  protect_from_forgery except: [:quote_creation, :tag_creation]
  def quote_creation
    if params[:user_token]

      @user = User.find_by(token: params[:user_token])
      @quote = QuoteHandler.create_for_user(params, @user.id)
      callback = params[:callback]
      html = ""

      respond_to do |format|
        # If the quote was successfully saved
        if @quote.save
          @user.board.quotes << @quote
          @tags = @user.unique_tags

          html = render_to_string(partial: "bookmarklet", layout: false, locals: {
            tags: @tags,
            title: "Saved.",
            subtitle: "Adding tags helps you find a quote again."
          })
        else
          callback = "failed"
          html = render_to_string(partial: "bookmarklet", layout: false, locals: {
            tags: nil,
            title: "Failed to save.",
            subtitle: "This is most likely our fault."
          })
        end

        # Respond with data{…} sent to the function added(…) in the bookmarklet
        format.json { render json: { html: html, quote_id: @quote.id }, callback: callback, layout: false }
      end
    end
  end

  def tag_creation
    if params[:user_token]

      # Ensures the Tag exists
      @tag = TagHandler.find_or_initialize(params[:tag])

      # Add tag to the Quote's tags
      @quote = Quote.find(params[:quote_id])
      @quote.tags << @tag

      # Get all the users unique tags from the users board
      @user = User.find_by(token: params[:user_token])
      @tags = @user.unique_tags

      # Return a set with tags inersecting the user's tags and the quote's.
      # Mark all these as existing.
      (@tags & @quote.tags).each do
        |tag| tag.is_existing = true
      end
    end

    respond_to do |format|
      # Sending Bookmarklet partial as stringified HTML to Bookmarklet.
      html = render_to_string(partial: "bookmarklet", layout: false, locals: {
        tags: @tags,
        title: "Added the tag ##{@tag.name}.",
        subtitle: "Tags help you find quotes later."
      })

      # Respond with data{…} sent to the function added(…) in the bookmarklet
      format.json { render json: { html: html }, callback: params[:callback]}
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
