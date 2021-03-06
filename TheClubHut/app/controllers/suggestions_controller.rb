class SuggestionsController < ApplicationController
  helper :clubavatar
  # GET /suggestions
  # GET /suggestions.xml
  def index
    session[:club_id] = nil
    @suggestions = Suggestion.find(:all)
    @title = "Suggestions"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @suggestions }
    end
  end

  # GET /suggestions/1
  # GET /suggestions/1.xml
  def show
    @suggestion = Suggestion.find(params[:id])
    @title = "Suggestions"
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @suggestion }
    end
  end

  # GET /suggestions/new
  # GET /suggestions/new.xml
  def new
    @suggestion = Suggestion.new
    @title = "New Suggestion"
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @suggestion }
    end
  end

  # GET /suggestions/1/edit
  def edit
    @suggestion = Suggestion.find(params[:id])
    @title = "Edit Suggestion"
  end

  # POST /suggestions
  # POST /suggestions.xml
  def create
    @suggestion = Suggestion.new(params[:suggestion])
    @title = "Create Suggestion / Idea / Bug Report / Request"
    respond_to do |format|
      if @suggestion.save
        flash[:notice] = 'Suggestion was successfully created.'
        format.html { redirect_to(@suggestion) }
        format.xml  { render :xml => @suggestion, :status => :created, :location => @suggestion }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @suggestion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /suggestions/1
  # PUT /suggestions/1.xml
  def update
    @suggestion = Suggestion.find(params[:id])

    respond_to do |format|
      if @suggestion.update_attributes(params[:suggestion])
        flash[:notice] = 'Suggestion was successfully updated.'
        format.html { redirect_to(@suggestion) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @suggestion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /suggestions/1
  # DELETE /suggestions/1.xml
  def destroy
    @suggestion = Suggestion.find(params[:id])
    @suggestion.destroy

    respond_to do |format|
      format.html { redirect_to(suggestions_url) }
      format.xml  { head :ok }
    end
  end
end
