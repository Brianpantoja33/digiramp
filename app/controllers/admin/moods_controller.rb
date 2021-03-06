class Admin::MoodsController < ApplicationController
  before_action :admin_only

  def index
    @moods = Mood.search(params[:query]).order('lower(title) ASC').page(params[:page]).per(32)
  end
  
  def new
    @mood = Mood.new
  end
  
  def create
    if @mood = Mood.create(mood_params)
      
      redirect_to_return_url admin_moods_path
    else
      redirect_to :back
    end
    
  end

  def edit
    @mood = Mood.cached_find(params[:id])
    
  end
  
  def update
    
    @mood = Mood.find(params[:id])
    if @mood.update_attributes(mood_params)
     
      redirect_to admin_moods_path
    else
      redirect_to :back
    end
    
  end
  
  def destroy
    @mood = Mood.find(params[:id])
    @mood.destroy!
   
    redirect_to_return_url admin_moods_path
  end
private
  def mood_params
    params.require(:mood).permit! if super?
  end
end
