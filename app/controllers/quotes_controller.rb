class QuotesController < ApplicationController

    include QuotesHelper

    def add_quote
    # Find user
    @user = User.find_by_token(params[:user_token])

    # Set, or if non existing, create, a source for the quote
    @source = Source.find_by_hostname(url_to_hostname(params[:url])) || Source.create!(:hostname => url_to_hostname(params[:url]), :favicon => URI.unescape(params[:favicon]))

    # Create a quote and connect it to the created source
    if @user && @source
      @quote = Quote.new(:text => URI.unescape(params[:text]), :user_id => @user.id, :url => URI.unescape(params[:url]), :source_id => @source.id)
      @quote.boards << @user.boards.first
      @quote.save
    end

    respond_to do |format|
      if @quote
        data = { :message => "Saved.", :submessage => "Add some tags?", :action => "tags", :qid => @quote.id, :tags => @user.boards.first.owned_tags }
        format.json { render json: data, callback: "status" }
      else
        data = { :message => "Service down.", :submessage => "Update bookmarklet or try later.", :action => "tags" }
        format.json { render json: data, callback: "status" }
      end
    end
  end

  def local_add_tag
    if session[:user_id]
      # Find users board through user session
      @board = User.find(session[:user_id]).boards.first

      # Find the quote we are adding tags to
      @quote = Quote.find(params[:qid])

      # Extract the tag
      @new_tag = URI.unescape(params[:tag])
      @quote.tag_list.add(@new_tag)
      # @tags = merge_tags(@quote.tags, @new_tag)

      # Add the tag to the quote, owned by the board
      @board.tag(@quote, :with => @quote.tag_list, :on => "tags")
    end

    respond_to do |format|
      if @board.save
        @is_new = params[:is_new]
        @tag = @quote.tags.find_by_name(@quote.tag_list.last)
        format.js
      else
        data = { :message => "Tagging failed." }
        format.js
      end
    end

  end

  def remote_add_tag
    if params[:user_token]
      @board = User.find_by_token(params[:user_token]).boards.first
    end

    @quote = Quote.find(params[:qid])

    @tag = URI.unescape(params[:tag])
    @tags = merge_tags(@quote.tags, @tag)

    @board.tag(@quote, :with => @tags, :on => "tags")

    respond_to do |format|
      if @board.save
        data = { :message => "added!", :submessage => "Close this popup when done.", :tag => @tag, :is_new => params[:is_new] }
        format.json { render json: data, callback: "added" }
      else
        data = { :message => "Tagging failed." }
        format.json { render json: data, callback: "added"}
      end
    end
  end

  # PUT /quotes/1
  # PUT /quotes/1.json
  def update
    @quote = Quote.find(params[:id])

    respond_to do |format|
      if @quote.update_attributes(params[:quote])
        format.html { redirect_to @quote, notice: 'Quote was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotes/1
  # DELETE /quotes/1.json
  def destroy
    @quote = Quote.find(params[:id])
    @quote.destroy
    respond_to do |format|
      format.html { redirect_to boards_url }
      format.json { head :no_content }
    end
  end

  def remove_tag
    @quote = Quote.find(params[:id])
    @tag_id = params[:tag_id]

    # Fetch the tag object
    @tag = @quote.tags.find(params[:tag_id])

    # Remove the tag from the quotes tag list (has to be done before the taggings count method below)
    @quote.tag_list.remove(@quote.tags.find(params[:tag_id]).name)

    # Save tag list changes
    if @quote.save 
      @tag.reload # Reload @tag to get latest tag count

      # If it is the last instance of the tag, remove it completely from the board, else only from this specific quote
      if(@tag.taggings_count <= 2)
        @tag.destroy
        @tag_destroyed = true 
      else
        @tag_destroyed = false
      end

      # Render remove_tag.js.erb
      respond_to do |format|
        format.js
      end
    end
  end
end
