module FullformHelper

  def update_seasons
   remote_function :url => {:action => :list_seasons }, :method => :get, :with => "'id='+value", :update => "season_id_container"
  end

end
