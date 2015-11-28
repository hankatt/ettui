class JsonpController < ApplicationController
  def tag_creation
    if params[:user_token]

      @user = User.find_by(token: params[:user_token])
      @quote = Quote.find(params[:quote_id])
      @board = @user.board

      # Important to downcase for searchability
      @tag = Tag.find_or_initialize_by(name: URI.unescape(params[:tag]).downcase)

      if @tag.new_record? && @tag.valid?
        @tag.save
        @tag.is_new = true
      else
        @tag.is_existing = true
      end
      @quote.tags << @tag
      @tags = @user.unique_tags # Get all the users unique tags from the users board
    end


    respond_to do |format|
      (@tags & @quote.tags).each do |tag| tag.is_existing = true end
      # @tags.detect{ |tag| tag.id == @tag.id }.is_existing = true
      html = render_to_string(partial: "bookmarklet", layout: false, locals: {
        tags: @tags,
        title: "Added the tag ##{@tag.name}.",
        subtitle: "Tags help you to easily find quotes later."
      })

      # Respond with data{…} sent to the function added(…) in the bookmarklet
      format.json { render json: { html: html }, callback: params[:callback]}
    end
  end

  def quote_creation
    @user = User.find_by(token: params[:user_token])

    url = URI.unescape(params[:url])
    hostname = HostnameParser.parse(url)
    favicon_url = URI.unescape(params[:favicon])
    text = URI.unescape(params[:text])

    @source = Source.find_by(hostname: hostname) ||
              Source.create(hostname: hostname, favicon: favicon_url)

    readability_response = ReadabilityResponse.new(params[:url])

    @quote = Quote.new(
      text: text,
      url: url,
      readability_title: readability_response.title,
      readability_author: readability_response.author,
      user_id: @user.id,
      source_id: @source.id
    )

    # Variables for the respond_to do |format|, defined in the if else.
    html = ""
    callback = params[:callback]
    if @quote.save

      @user.board.quotes << @quote
      @tags = @user.unique_tags

      html = render_to_string(partial: "bookmarklet", layout: false, locals: {
        tags: @tags,
        title: "The quote was saved.",
        subtitle: "Adding tags helps you to easily find it again."
      })
    else

      callback = "failed"

      html = render_to_string(partial: "bookmarklet", layout: false, locals: {
        tags: nil,
        title: "The quote failed to save.",
        subtitle: "This is most likely an error on our end."
      })
    end

    respond_to do |format|
      format.json{ render json: { html: html, quote_id: @quote.id }, callback: callback, layout: false }
    end
  end
end
