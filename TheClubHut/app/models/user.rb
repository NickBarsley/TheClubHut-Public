require 'digest/sha1'
require 'md5'
require 'date'

class User < ActiveRecord::Base 
  has_one :spec
  has_one :blog
  has_one :forum
  has_many :post
  has_many :substitute
  has_many :comments, :order => "created_at DESC", :dependent => :destroy
  has_many :teammember
  has_many :committeemember  
  has_many :review
  has_many :suggestion
  has_many :race, :order => "surname DESC"
  has_many :booking
  has_many :membership

           
  def full_name
    [firstname, surname].join(' ')
  end
  
  def list_name
    [surname, firstname].join(', ')
  end
  
  # Friendship Connection
  has_many :friendships
  
  has_many :friends,
           :through => :friendships,
           :conditions => "status = 'accepted'",
           :order => :firstname

  has_many :requested_friends,
           :through => :friendships,
           :source => :friend,
           :conditions => "status = 'requested'",
           :order => :created_at
           

  has_many :pending_friends,
           :through => :friendships,
           :source => :friend,
           :conditions => "status = 'pending'",
           :order => :created_at             


	has_many :moderatorships, :dependent => :destroy
	has_many :forums, :through => :moderatorships, :order => "#{Forum.table_name}.name"

	has_many :posts
	has_many :topics
	has_many :monitorships
	has_many :monitored_topics, :through => :monitorships, :conditions => ["#{Monitorship.table_name}.active = ?", true], :order => "#{Topic.table_name}.replied_at desc", :source => :topic
  

	#implement in your user model 
	def admin?
		true
	end
	
	def nick?
    if session[:user_id].to_i == 6
      true
    else
      false
    end
	end
  
	
  def moderator_of?(forum)
    moderatorships.count(:all, :conditions => ['forum_id = ?', (forum.is_a?(Forum) ? forum.id : forum)]) == 1
  end

  def to_xml(options = {})
    options[:except] ||= []
    super
  end

  attr_accessor :remember_me
  attr_accessor :current_password
  before_save :cipher_password!
  
  # Max & min lengths for all fields 
  FIRSTNAME_MIN_LENGTH = 2 
  FIRSTNAME_MAX_LENGTH = 40 
  FIRSTNAME_RANGE = FIRSTNAME_MIN_LENGTH..FIRSTNAME_MAX_LENGTH 
  FIRSTNAME_SIZE=20

  SURNAME_MIN_LENGTH = 2 
  SURNAME_MAX_LENGTH = 40 
  SURNAME_RANGE = SURNAME_MIN_LENGTH..SURNAME_MAX_LENGTH 
  SURNAME_SIZE=20
  
  EMAIL_MAX_LENGTH = 50 
  EMAIL_SIZE = 30 
  
  PASSWORD_MIN_LENGTH = 4 
  PASSWORD_MAX_LENGTH = 40 
  PASSWORD_RANGE = PASSWORD_MIN_LENGTH..PASSWORD_MAX_LENGTH 
  PASSWORD_SIZE = 20

  validates_length_of     :firstname,     :within => FIRSTNAME_RANGE
  validates_presence_of   :firstname
  
  validates_length_of     :surname,     :within => SURNAME_RANGE
  validates_presence_of   :surname 

  validates_uniqueness_of :email 
  validates_length_of :email, :maximum => EMAIL_MAX_LENGTH 
  validates_format_of :email, 
                        :with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i,
                        :message => "must be a valid email address"
  
  validates_length_of :password, :within => PASSWORD_RANGE 
  validates_presence_of :password
  validates_confirmation_of :password

  def display_name
    [firstname, surname].join(" ")
  end
  
  # Log a user in.
  def login!(session)
    session[:user_id] = id
  end
  
  # Log a user out.
  def self.logout!(session, cookies)
    session[:user_id] = nil
    cookies.delete(:authorization_token)
  end
  
  # Clear the password (typically to suppress its display in a view).
  def clear_password!
    self.password = nil
    self.password_confirmation = nil
    self.current_password = nil
  end
  
  # Return true if the password from params is correct.
  def correct_password?(params)
    # Encrypt the password supplied.
#    current_password = MD5.new(params[:user][:current_password]).to_s unless params[:user][:current_password].to_s =~ /^[\dabcdef]{32}$/    
    # Compare it to the already encrypted one stored in the DB.
    password == MD5.new(params[:user][:current_password]).to_s unless params[:user][:current_password].to_s =~ /^[\dabcdef]{32}$/
  end

  # Generate messages for password errors.
  def password_errors(params)
    # Use User model's valid? method to generate error messages 
    # for a password mismatch (if any).
    self.password = MD5.new(params[:user][:password]).to_s unless params[:user][:password].to_s =~ /^[\dabcdef]{32}$/    
    self.password_confirmation = MD5.new(params[:user][:password_confirmation]).to_s unless params[:user][:password_confirmation].to_s =~ /^[\dabcdef]{32}$/    
    valid?
    # The current password is incorrect, so add an error message.
    errors.add(:current_password, "is incorrect")
  end
  
  # Remember a user for future login.
  def remember!(cookies)
#    cookie_expiration = 20.years.from_now
    cookie_expiration = Time.now + 2.years

    cookies[:remember_me] = { :value   => "1",
                              :expires =>  cookie_expiration }
    self.authorization_token = unique_identifier
    save!
    cookies[:authorization_token] = { :value   => authorization_token,
                                      :expires => cookie_expiration }
  end
  
  # Forget a user's login status.
  def forget!(cookies)
    cookies.delete(:remember_me)
    cookies.delete(:authorization_token)
  end

  # Return true if the user wants the login status remembered.
  def remember_me?
    remember_me == "1"
  end

  def avatar
    Avatar.new(self)
  end

  #implement in your user model 
	def self.currently_online
		true
	end
	
	def currently_online.empty?
    false
	end
  
	
	def search(query, options = {})
		with_scope :find => { :conditions => build_search_conditions(query) } do
			options[:page] ||= nil
			paginate options
		end
	end
	
	#implmement to build search coondtitions
	def build_search_conditions(query)
		# query && ['LOWER(display_name) LIKE :q OR LOWER(login) LIKE :q', {:q => "%#{query}%"}]
		query
	end
	
	def moderator_of?(forum)
		moderatorships.count("#{Moderatorship.table_name}.id", :conditions => ['forum_id = ?', (forum.is_a?(Forum) ? forum.id : forum)]) == 1
	end
	
	def to_xml(options = {})
		options[:except] ||= []
		options[:except] << :email << :login_key << :login_key_expires_at << :password_hash << :openid_url << :activated << :admin
		super
	end
	
	def update_posts_count
		self.class.update_posts_count id
	end
	
	def update_posts_count(id)
		User.update_all ['posts_count = ?', Post.count(:id, :conditions => {:user_id => id})],   ['id = ?', id]
	end

  private
  # Cipher password
  def cipher_password!
  	unless password.to_s =~ /^[\dabcdef]{32}$/
  		write_attribute("password", MD5.new(password).to_s)
  		# this is needed for virtual validation
  		@password_confirmation = MD5.new(@password_confirmation).to_s if @password_confirmation
  	end
  end
  
  # Generate a unique identifier for a user.
  def unique_identifier
    Digest::SHA1.hexdigest("#{email}:#{password}")
  end
  

		
  
  include SavageBeast::UserInit
  
end
