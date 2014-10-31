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
      else
        parsed["title"] = "Noted: Installing the Bookmarklet"
      end

      @quote = Quote.new({
        :text => URI.unescape(params[:text]), 
        :user_id => @user.id, 
        :url => URI.unescape(params[:url]), 
        :source_id => @source.id,
        :readability_title => parsed["title"] || ""
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
      # Find users board through user session
      @board = User.find(session[:user_id]).boards.first

      # Find the quote we are adding tags to
      @quote = Quote.find(params[:qid])

      # Extract the tag
      tag = URI.unescape(params[:tag])

      # Flags used in local_add_tag.js.erb, to decide what to do with the UI
      @flags = { :flash => false, :add => false }

      if @quote.has_tag(tag)
        # Flash existing tag on quote and on popup
        @flags[:flash] = true

      else
        # Attach tag to the quote owned by the user's board
        tags = @quote.append_tag(tag)

        # Board
        @board.tag(@quote, :with => tags, :on => "tags" )
        @quote.reload

        # Add tag on on quote and in popup
        @flags[:add] = true
      end
    end

    respond_to do |format|
      if @board.save
        # Set @tag to represent the Tag object (for local_add_tag.js.erb)
        @tag = @quote.tags.find_by_name(URI.unescape(params[:tag]))
        @tag.set_context_count(@board)
        format.js
      else
        data = { :message => "Tagging failed." }
        format.js
      end
    end
  end

  def add_tag_remote
    if params[:user_token]
      @board = User.find_by_token(params[:user_token]).boards.first

      # Find the quote we are adding tags to
      @quote = Quote.find(params[:qid])

      # Extract the tag
      tag = URI.unescape(params[:tag])

      # Flags used in local_add_tag.js.erb, to decide what to do with the UI
      @flags = { :update => false, :add => false }

      if @board.owns_tag(tag)
        @flags[:update] = true  # If it exists:   Update its status to 'selected'
      else
        @flags[:add] = true     # If it is new:   Append it to the list
      end

      # If the tag does not already have the tag: Add it.
      if !@quote.has_tag(tag)
        # Attach tag to the quote owned by the user's board
        tags = @quote.append_tag(tag)

        # Update tags on the quote
        @board.tag(@quote, :with => tags, :on => "tags")
      end
    end

    respond_to do |format|
      if @board.save

        @quote.reload # Update quote when tag is saved
        @tag = @quote.tags.find_by_name(URI.unescape(params[:tag])) # Retrieve the actual tag

        # General callback data set
        data = { 
          :message => "exists.", 
          :submessage => "It is already selected.", 
          :tag => @tag, 
          :add => @flags[:add], 
          :update => @flags[:update]
        }

        # Case dependent callback data
        if @flags[:update]
          data[:message] = "exists."
          data[:submessage] = "It has been selected below."
        elsif @flags[:add]
          data[:message] = "added!"
          data[:submessage] = "Close this popup when done."
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

    @user = current_user
    @quote = Quote.find(params[:id])

    # URL to Readability's Parser API
    uri = URI('http://www.readability.com/api/content/v1/parser')

    # Our query to the Parser API
    params = {
      :url => @quote.url,
      :token => '34831792edfc0cf8e42b3e82086f00970a53407b'
    }

    # Format params for web encoding
    uri.query = URI.encode_www_form(params)

    # Readability Parser response
    response = Net::HTTP.get_response(uri)
    @parsed = ActiveSupport::JSON.decode(response.body)

    respond_to do |format|
      format.html
      format.json
    end
  end

  def remove_tag
    @quote = Quote.find(params[:id])
    @tag = @quote.tags.find(params[:tag_id])
    @board = @quote.boards.first
    
    # Variables for remove_tag.js.erb
    @flags = { :tags_remain => false }
    if(@tag.taggings_count > 1)
      @flags[:tags_remain] = true
    end

     # Remove tag from quote
    tags = @quote.remove_tag(@tag)

    # Apply the new tags list to @quote and board
    @board.tag(@quote, :with => tags, :on => "tags")

    @tag.reload # Reload @tag to get latest tag count

    # Render remove_tag.js.erb
    respond_to do |format|
      @tag.set_context_count(@board)
      format.js
    end
  end

  def update_quotes_with_readability_parse_data
    
    # URL to Readability's Parser API
    uri = URI('http://www.readability.com/api/content/v1/parser')
    token = '34831792edfc0cf8e42b3e82086f00970a53407b'

    Quote.all.each do |quote|
      if quote.readability_title.nil?
        # Format params for web encoding
        uri.query = URI.encode_www_form({:url => quote.url, :token => token })

        # Readability Parser response
        response = Net::HTTP.get_response(uri)
        parsed = ActiveSupport::JSON.decode(response.body)

        # Update attributes
        quote.update_attributes(:readability_title => parsed["title"])
      end
    end

    respond_to do |format|
      format.html { redirect_to boards_path, notice: 'All quotes successfully updated.' }
    end
  end

end
