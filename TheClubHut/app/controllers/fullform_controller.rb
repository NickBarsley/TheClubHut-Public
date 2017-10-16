class FullformController < ApplicationController
  helper :clubavatar, :teams

  def newteam
    @club = Club.new
    @season = Season.new
    @team = Team.new
    @team.teammember.build
    @event = Event.new
    @title = "Create a New Team, Event or Result"

  end

  def createteam
    # Club options
    if params[:switcher] == "on" and params[:club][:id] != ""
      # User has selected an existing club.
      @club = Club.find(params[:club][:id])
      params[:club].delete(:navigation_attributes)
    else
      # User has created a new club.
      params[:club].delete(:id)
      @club = Club.new(params[:club])  
    end

    # Season options.
    if params[:season_switch] == "on"
      # User has selected an existing season for the club above.
      @season = Season.find(params[:season][:id])
    else
      @season = @club.season.build(params[:season])  
    end

    if @club.save 
        # Team options.
        if params[:team_switch] == "on"
          # User has selected an existing team for the season above.
          @team = Team.find(params[:team][:id])
        else
          # new team.
          params[:team][:club_id] = @club.id
          params[:team][:season_id] = @season.id
          @team = Team.new(params[:team])
        end
      if @team.save
        session[:club_id] = @club.id
        redirect_to :controller => "seasons", :action => "show", :id => @season.id
      else
        render :action => 'newteam'
      end
      
    else
      render :action => 'newteam'
    end
  end
  

  
  def list_seasons
    if params[:id].blank?
      @html = "<b>Choose a Season</b><BR />" + %Q{<select id="season_id" onchange="new Ajax.Updater('team_id_container', '/fullform/list_teams', {asynchronous:true, evalScripts:true, parameters:'season_id='+escape(value)})" name="season[id]" disabled='disabled'><option value=''>No Club Selected</option></select>}
    else
      @seasons = Season.find(:all, :conditions => ["club_id=?", params[:id]], :order => "starts_from DESC")
      if @seasons.size == 0
        @html = "<b>Choose a Season</b><BR />" + %Q{<select id="season_id" onchange="new Ajax.Updater('team_id_container', '/fullform/list_teams', {asynchronous:true, evalScripts:true, parameters:'season_id='+escape(value)})" name="season[id]" disabled='disabled'><option value=''>No Seasons Found</option></select>}
        @htmlteam = "<b>Choose a Team</b><BR /><select id='team_id' name='team[id]' disabled='disabled'><option value=''>No Teams Found</option></select>"
      else                                   
        @html = "<b>Choose a Season</b><BR />" + %Q{<select id="season_id" onchange="new Ajax.Updater('team_id_container', '/fullform/list_teams', {asynchronous:true, evalScripts:true, parameters:'season_id='+escape(value)})" name="season[id]">}
        i = 0
        @seasons.each do |season|
           @html += "<option value='#{season.id}'>#{season.description}</option>"
           if i == 0
             @firstteams = Team.find(:all, :conditions => ["season_id=?", season.id]) 
            if @firstteams.size == 0
              @htmlteam = "<b>Choose a Team</b><BR /><select id='team_id' name='team[id]' disabled='disabled'><option value=''>No Teams Found</option></select>"
            else
              @htmlteam = "<b>Choose a Team</b><BR /><select id='team_id' name='team[id]'>"
              @firstteams.each do |team|
                 @htmlteam += "<option value='#{team.id}'>#{team.description}</option>"
              end
              @htmlteam += "</select>"  
            end
           end
           i += 1
        end
        @html += "</select>"  

      end
    end
    

    
    #render:text => @html.to_s
    render :update do |page|
      page.replace_html :season_id_container, @html.to_s
      page.replace_html :team_id_container, @htmlteam.to_s
    end
    
  end
  
  def list_teams
    if params[:season_id].blank?
      @html = "<b>Choose a Team</b><BR /><select id='team_id' name='team[id]' disabled='disabled'><option value=''>No Club Selected</option></select>"
    else
      @teams = Team.find(:all, :conditions => ["season_id=?", params[:season_id]])
      if @teams.size == 0
        @html = "<b>Choose a Team</b><BR /><select id='team_id' name='team[id]' disabled='disabled'><option value=''>No Teams Found</option></select>"
      else
        @html = "<b>Choose a Team</b><BR /><select id='team_id' name='team[id]'>"
        @teams.each do |team|
           @html += "<option value='#{team.id}'>#{team.description}</option>"
        end
        @html += "</select>"  
      end
    end
    render:text => @html.to_s
    

  end
  
end
