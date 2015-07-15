class TagsController < ApplicationController

  def create

    @quote = Quote.find(params[:quote_id])


    tag = Tag.find_or_initialize_by(tag_params)

    if tag.new_record? && tag.valid?
      tag.name.downcase!
      tag.save
    else
      # validations failed so you should let the user know
    end

    @quote.tags << tag

    respond_to do |format|
      format.html { redirect_to boards_path }
    end
  end

  def destroy
    @quote = Quote.find(params[:quote_id])

    tag = Tag.find(params[:id])

    if tag.last_instance?
      tag.destroy
    else
      @quote.tags.delete(tag)
    end

    respond_to do |format|
      format.html { redirect_to boards_path }
    end
  end

  def add_tag_remote
    if params[:user_token]

      @user = User.find_by_token(params[:user_token])
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
    end


    respond_to do |format|
      @tags = @user.unique_tags # Get all the users unique tags from the users board
      (@tags & @quote.tags).each do |tag| tag.is_existing = true end
      # @tags.detect{ |tag| tag.id == @tag.id }.is_existing = true
      html = render_to_string(:partial => "bookmarklet/content", layout: false, locals: {
        tags: @tags,
        tag: @tag,
        title: "Added the tag ##{@tag.name}.",
        subtitle: "Tags help you to easily find quotes later."
      })

      # Respond with data{…} sent to the function added(…) in the bookmarklet
      format.json { render json: { :html => html }, callback: "added"}
    end
  end

private
  def tag_params
    params.require(:tag).permit(:name)
  end
end
