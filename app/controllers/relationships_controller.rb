# https://www.railstutorial.org/book/following_users
class RelationshipsController < ApplicationController
  # convert to Ajax
  def create
    ap params
    @user = User.find(params[:user][:followed_id])
    if relationship              = current_user.follow!(@user)
      @user.followers_count      = @user.followers.count
      @user.uniq_followers_count = @user.followers_count.to_uniq
      @user.save!
      Activity.notify_followers( 'is following', current_user.id, 'User' , relationship.followed_id )        
    end    

  end

  def destroy
    relationship      = Relationship.cached_find(params[:id])
    @relationship_id  = relationship.id
    @user             = relationship.followed
    
    @user.followers_count -= 1
    @user.save
    
    current_user.unfollow!(@user)
    #@remove_button    = "#unfollow_user_#{@user.id.to_s}"
    #@add_button       = "#follow_unfollow_#{@user.id.to_s}"  
  end
end