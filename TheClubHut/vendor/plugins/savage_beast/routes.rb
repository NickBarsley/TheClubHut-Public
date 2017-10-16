ActionController::Routing::Routes.draw do |map|

  map.resources :posts, :name_prefix => 'all_', :collection => { :search => :get }
	map.resources :forums, :member => { :newclub => :get }
	map.resources :topics, :posts, :monitorship

  %w(forum).each do |attr|
    map.resources :posts, :name_prefix => "#{attr}_", :path_prefix => "/#{attr.pluralize}/:#{attr}_id"
  end
  
  map.resources :forums, :member => { :newclub => :get } do |forum|
    forum.resources :topics do |topic|
      topic.resources :posts
      topic.resource :monitorship, :controller => :monitorships
    end
  end

end