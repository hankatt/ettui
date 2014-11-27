class QuotesController < ApplicationController

    include QuotesHelper

    def add_quote
    # Find user
    @user = User.find_by_token(params[:user_token])

    # Set, or if non existing, create, a source for the quote
    @source = Source.find_by_hostname(url_to_hostname(params[:url])) || Source.create!(:hostname => url_to_hostname(params[:url]), :favicon => URI.unescape(params[:favicon]))

    # Create a quote and connect it to the created source
    if @user && @source

      # URL to Readability's Parser API
      uri = URI('http://www.readability.com/api/content/v1/parser')
      token = '34831792edfc0cf8e42b3e82086f00970a53407b'
      url = URI.unescape(params[:url])

      if(!url.include? "notedapp.herokuapp.com")
        # Format params to web form format
        uri.query = URI.encode_www_form({:url => url, :token => token })
        
        # Readability Parser response
        response = Net::HTTP.get_response(uri)
        parsed = ActiveSupport::JSON.decode(response.body)

        # Attributes to update
        @title = parsed["title"]
        @author = parsed["author"]

        # Validate that it is just the author
        # Assume most names won't use more than 4 names tops
        # Assume most names won't be that long, 34 chars tops
        if @author.nil? || @author.scan(/\w+/).size > 4 || @author.length > 34
          @author = nil
        end

      else
        @title = "Noted: Installing the Bookmarklet"
        @author = nil
      end

      @quote = Quote.new({
        :text => URI.unescape(params[:text]), 
        :user_id => @user.id, 
        :url => url, 
        :source_id => @source.id,
        :readability_title => @title,
        :readability_author => @author
      })

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

  def add_tag_local
    if session[:user_id]
      @board = User.find(session[:user_id]).boards.first
      @quote = Quote.find(params[:qid])

      # Flags used in local_add_tag.js.erb
      @flags = { :add => false }

      if @quote.add_tag(URI.unescape(params[:tag]).downcase)
        @flags[:add] = true # Tag is new, add to UI
      end

      @tag = @quote.tags.find_by_name(URI.unescape(params[:tag]).downcase)
      @tag.update_tag_count_on(@board)
    end

    respond_to do |format|
      if @board.save
        format.js
      else
        data = { :message => "Tagging failed." }
        format.js
      end
    end
  end

    def remove_tag
    @quote = Quote.find(params[:id])
    @tag = @quote.tags.find(params[:tag_id])
    @board = @quote.boards.first

    # Remove the tag
    @quote.remove_tag(@tag.name)

    # Count tag occurences on @board
    @tag.update_tag_count_on(@board)

    # Render remove_tag.js.erb
    respond_to do |format|

      if @board.save
        format.js
      end
    end
  end

  def add_tag_remote
    if params[:user_token]
      @board = User.find_by_token(params[:user_token]).boards.first
      @quote = Quote.find(params[:qid])

      # Extract the tag (important to downcase for searchability further down)
      tag = URI.unescape(params[:tag]).downcase

      # Flags used in local_add_tag.js.erb, to decide what to do with the UI
      @flags = { 
        :update => false,
        :add => false
      }

      if @quote.add_tag(URI.unescape(params[:tag]).downcase)
        if !@board.owns_tag(tag)
          @flags[:add] = true # It's new: Append it to the popup list
        end
      else
        @flags[:update] = true
      end

      @tag = @quote.tags.find_by_name(tag) # Retrieve the actual tag
      @tag.update_tag_count_on(@board)

    end

    respond_to do |format|
      if @board.save

        # General callback data set
        data = { 
          :message => "is added!", 
          :submessage => "Close this popup when done.", 
          :tag => @tag, 
          :add => @flags[:add], 
          :update => @flags[:update]
        }

        # Case dependent callback data
        if @flags[:update]
          data[:message] = "exists!"
          data[:submessage] = "It has been selected."
        end

        # Do the callback
        format.json { render json: data, callback: "added" }

      else

        data = { :message => "Tagging failed.", :submessage => "Could not update your board." }
        format.json { render json: data, callback: "added"}

      end
    end
  end

  def append_tag_input
    if session[:user_id]
      # Find the quote we are adding tags to
      @quote = Quote.find(params[:id])

      # Parse out unused tags (used to suggest tags based on previous taggings)
      all_tags = User.find(session[:user_id]).boards.first.owned_tags
      @unused_tags = all_tags.reject{|x| (@quote.tags.pluck(:id).uniq).include? x.id} # Filter out used tags
    end

    respond_to do |format|
      format.js # local_add_tag_popup
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

  def show

    @quote = Quote.find(params[:id])
    @board = @quote.boards.first
    

    respond_to do |format|
      format.html
      format.json
    end
  end

  def update_readability_data
    quotes = current_user.boards.first.quotes.all
    quotes.each do |quote|
      quote.update_readability_data
    end

    respond_to do |format|
      format.html { redirect_to boards_path, notice: 'All quotes successfully updated.' }
    end
  end

end
