class FriendshipController < ApplicationController
  include ProfileHelper
  before_filter :protect, :setup_friends
    helper :clubavatar
  # Send a friend request.
  # We'd rather call this "request", but that's not allowed by Rails.
  def create
    Friendship.request(@user, @friend)
    #UserMailer.deliver_friend_request(
    #  :user => @user,
    #  :friend => @friend,
    #  :user_url => profile_for(@user),
    #  :accept_url =>  url_for(:action => "accept",  :id => @user.firstname),
    #  :decline_url => url_for(:action => "decline", :id => @user.firstname)
    #)
    #flash[:notice] = "Friend request sent."
    redirect_to :controller => "profile", :action => "show", :id => @friend.id
  end

  def accept
    if @user.requested_friends.include?(@friend)
      Friendship.accept(@user, @friend)
      flash[:notice] = "Friendship with #{@friend.firstname} accepted!"
    else
      flash[:notice] = "No friendship request from #{@friend.firstname}."
    end
    redirect_to :controller => "profile", :action => "show"
  end
  
  def decline
    if @user.requested_friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:notice] = "Friendship with #{@friend.firstname} declined"
    else
      flash[:notice] = "No friendship request from #{@friend.firstname}."
    end
    redirect_to :controller => "profile", :action => "show"
  end
  
  def cancel
    if @user.pending_friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:notice] = "Friendship request canceled."
    else
      flash[:notice] = "No request for friendship with #{@friend.firstname}"
    end
    redirect_to :controller => "profile", :action => "show"
  end
  
  def delete
    if @user.friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:notice] = "Friendship with #{@friend.firstname} deleted!"
    else
      flash[:notice] = "You aren't friends with #{@friend.firstname}"
    end
    redirect_to :controller => "profile", :action => "show"
  end

  private 
  
  def setup_friends
    @user = User.find(session[:user_id])
    @friend = User.find(params[:id])
  end
end