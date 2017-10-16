
module SavageBeast

  module UserInit

    def self.included(base)
      base.class_eval do

      end
      base.extend(ClassMethods)
    end

    module ClassMethods			
				def update_posts_count
      		self.class.update_posts_count id
      	end
      	
      	def update_posts_count(id)
      		User.update_all ['posts_count = ?', Post.count(:id, :conditions => {:user_id => id})],   ['id = ?', id]
      	end

    end
      
  end
end