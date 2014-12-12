class UsersController < ApplicationController
  #respond_to :html, :xml, :json, :js
 
  #before_filter :find_user, only: [:show, :edit, :update, :destroy]
  before_filter :access_user, only: [:edit, :update, :destroy]
  before_filter :find_user, only: [:show]
  
  def index
    #@users = User.search(params[:query]).order('lower(user_name) ASC').page(params[:page]).per(48)
    @users = User.public_profiles.search(params[:query]).order('followers_count desc').page(params[:page]).per(48)
    
  end

  def show

    
    if current_user && @user != current_user
      @user.views += 1 
      @user.save
    end
    
    @user.create_activity(  :show, 
                              owner: current_user,
                          recipient: @user,
                     recipient_type: @user.class.name,
                         account_id: @user.account_id)
   
    ##############################################################
    # remove asap
    if @user.account_id.nil?
      unless account = Account.where(user_id: @user.id).first
        account = User.create_a_new_account_for_the @user
      end
      @user.account_id = account.id
      @user.validate_info
      @user.save!
    end
    #############################################################
    session[:account_id] = @user.account_id 
    
    if current_user 
      if current_user.current_account_id != current_user.account.id
        current_user.current_account_id  = current_user.account.id
        current_user.save!
      end
      @playlists  = current_user.playlists
      @authorized = false
      if current_user.id == @user.id || current_user.super?
        @authorized = true
      end
    end

  end
  
  def find_user
    @user = User.cached_find(params[:id])
    # If an old id or a numeric id was used to find the record, then
    # the request path will not match the post_path, and we should do
    # a 301 redirect that uses the current friendly id.
    if request.path != user_path(@user)
      return redirect_to @user, :status => :moved_permanently
    end
  end
  
  #def find_user
  #  if current_user
  #    @user = User.cached_find(params[:id])
  #  else
  #    render :file => "#{Rails.root}/public/422.html", :status => 422, :layout => false
  #  end
  #end


  def new

  end

  def edit
    @authorized = true
  end

  def create
    session[:show_profile_completeness] = true
    params[:user][:role]      = 'Customer'
    params[:user][:email].downcase! if params[:user][:email]
    user_name                 = User.create_uniq_user_name_from_email (params[:user][:email])
    params[:user][:user_name] = user_name
    @user                     = User.new(user_params)
                              
    blog                      = Blog.cached_find('Sign Up')

    if params[:user][:password]    != params[:user][:password_confirmation]
      flash[:danger]   = { error: 'Sorry:', body: 'Password and Passoword confirmation mismatch' }
      redirect_to signup_index_path
    
    elsif  params[:user][:email].to_s == ''
      flash[:danger]   = { error: 'Sorry:', body: 'Email is missing' }
      redirect_to signup_index_path
    
    elsif @user.save
      @account          = User.create_a_new_account_for_the @user
      blog              = Blog.cached_find('Sign Up')
      blog_post         = BlogPost.cached_find('Sucess', blog)
      flash[:success]   = { title: blog_post.title, body: blog_post.body }
      
      # signout if you was signed in as another user
      cookies.delete(:auth_token)
      sign_in
      
      
      @user.create_activity(  :created, 
                         owner: @user,
                     recipient: @user,
                recipient_type: @user.class.name,
                    account_id: @user.account_id) 
      
      
      
      
      
      
      redirect_to edit_user_path(@user)
      
      
      
    else
      flash[:danger]   = { title: 'Sorry:', body: 'Email has already been taken' }
      redirect_to signup_index_path
    end

  end

  def sign_in
    if @user && @user.authenticate(@user.password)
      cookies[:auth_token] = @user.auth_token
      
      @user.create_activity(  :signed_in, 
                         owner: @user,
                     recipient: @user,
                recipient_type: @user.class.name,
                    account_id: @user.account_id) 
                
                
    end
  end

  def update
    @account = @user.account
    @user.slug = nil
    params[:user][:email_missing] = false
    if @user.update(user_params)
      # show completeness if needed
      session[:show_profile_completeness] = true
      @user.flush_auth_token_cache(cookies[:auth_token])

      @user.create_activity(  :updated, 
                         owner: @user,
                     recipient: @user,
                recipient_type: @user.class.name,
                    account_id: @user.account_id)
                    
                    
                    
      
                                            
      redirect_to user_path(@user)
    else
      #if User.where(user_name: params[:user_name])
      #  flash[:danger] = { title: "Error", body: "User name alreaddy used" }
      #else
      #  flash[:danger] = { title: "Error", body: "Check if password and password confirmation" }
      #end
      
      render :edit
    end
    
  end

  def destroy
    #@user.activity_events.create! \
    #  activity_log_id: @account.activity_log.id,
    #  user_id: current_user.id,
    #  title: "Deleted #{@user.name}",
    #  r: true,
    #  activity_url: account_users_path( @account)
    
    @user.create_activity(  :destroyed, 
                       owner: @user,
                   recipient: @user,
              recipient_type: @user.class.name,
                  account_id: @user.account_id)
    
    flash[:info] = { title: "SUCCESS: ", body: "#{@user.name} is deleted" } 
    @user.destroy
    #go_to = session[:go_to_after_edit] || account_users_path(@account)
    session[:go_to_after_edit]  = nil
    redirect_to :back
  end
  
  
private

  def remove_password_fields_if_blank!(user_params)
    if user_params[:password].blank? and user_params[:password_confirmation].blank?
      user_params.delete :password
      user_params.delete :password_confirmation
    end
  end

  def user_params
    params.require(:user).permit!
  end
          
  
  
  
  #def find_user
  #  if current_user
  #    @user = User.cached_find(params[:id])
  #  else
  #    render :file => "#{Rails.root}/public/422.html", :status => 422, :layout => false
  #  end
  #end
  
  
  
  

  
  #def add_roles
  #  @roles = AccountUser::ROLES
  #  @roles << 'super'           if current_user.super?
  #  @roles << 'account owner'   if current_user.super?
  #  @roles.uniq!
  #end

end
