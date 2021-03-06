class User::CmsPagesController < ApplicationController
  before_action :set_cms_page, only: [:show, :edit, :update, :destroy]
  before_action :access_user
  
  protect_from_forgery only: :show
  def index
    @cms_pages = CmsPage.all
  end

  protect_from_forgery :except => :show
  def show

    if current_user && @user.id != current_user.id
      @user.views += 1 
      @user.save
    end
    
    if current_user && (@user.id == current_user.id || super?)
      @edit_page == true
    end
    
    
    
  end

  def new
    @cms_page = CmsPage.new
  end

  def edit
    
    @body_color = "#15141C"
    @image_url  = "https://digiramp.com/uploads/raw_image/image/24/music-enthusiasts.jpg"
    
    @user_activities = @user.user_activities.order('id desc').page(params[:page]).per(4)
    @playlists       = current_user.playlists
    
    
  end

  def create

    @cms_page = CmsPage.create(cms_page_params)
    redirect_to edit_user_user_cms_page_path(@user, @cms_page)

  end

  def update
    @cms_page.update(cms_page_params)
    redirect_to edit_user_user_cms_page_path(@user, @cms_page)

  end

  def destroy
    @cms_page.destroy
    redirect_to user_user_cms_pages_path(@user)
  end

  private
  def set_cms_page
    begin
      @cms_page = CmsPage.cached_find(params[:id])
    rescue
      not_found
    end
  end
    

  def cms_page_params
    params.require(:cms_page).permit!#( :user_id,
                                     # :title,            
                                     # :created_at,
                                     # :updated_at,
                                     # :background_color, 
                                     # :text_color,       
                                     # :layout,           
                                     # :hide_sidebar,     
                                     # :theme,            
                                     # :show_in_menu,     
                                     # :position,         
                                     # :cms_page_id)
  end
end
