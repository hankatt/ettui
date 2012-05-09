class QuotesController < ApplicationController
  # before_filter :allow_cors

  def allow_cors 
    headers["Access-Control-Allow-Origin"] = "*"
  end

  # GET /quotes
  # GET /quotes.json
  def index
    if cookies[:user_id]
      @user = User.find(cookies[:user_id])
    end

    @quotes = Quote.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quotes }
    end
  end

  def get_token
    respond_to do |format|
      format.json { render json: cookies[:user_id] }
    end
  end

  def remote_create
    if cookies[:user_id]
      @quote = Quote.create!(:text => params[:text], :user_id => cookies[:user_id], :source => params[:source])
      
      respond_to do |format|
        if @quote
          data = { :submit => true, :logged_in => true, :message => "Saved!" }
          format.json { render json: data, callback: "status" }
        else
          data = { :submit => false, :logged_in => true, :message => "Try again." }
          format.json { render json: data, callback: "status" }
        end
      end
    else
      respond_to do |format|
          data = { :submit => false, :logged_in => false, :message => "Please login." }
          format.json { render json: data, callback: "status" }
      end
    end
  end

  # GET /quotes/1
  # GET /quotes/1.json
  def show
    @quote = Quote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quote }
    end
  end

  # GET /quotes/new
  # GET /quotes/new.json
  def new
    @quote = Quote.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quote }
    end
  end

  # GET /quotes/1/edit
  def edit
    @quote = Quote.find(params[:id])
  end

  # POST /quotes
  # POST /quotes.json
  def create
    @quote = Quote.new(params[:quote])

    respond_to do |format|
      if @quote.save
        format.html { redirect_to @quote, notice: 'Quote was successfully created.' }
        format.json { render json: @quote, status: :created, location: @quote }
      else
        format.html { render action: "new" }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
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
      format.html { redirect_to quotes_url }
      format.json { head :no_content }
    end
  end
end
