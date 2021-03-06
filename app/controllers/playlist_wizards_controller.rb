class PlaylistWizardsController < ApplicationController
  include AccountsHelper
  before_action :access_account
  def index
  
  end
  
  def new
    
  end
  

  def show
    
  end

  def edit
    @playlist_key     = PlaylistKey.find(params[:id])
    @recordings       = Recording.not_in_bucket.account_search(@account, params[:query]).order('title asc').page(params[:page]).per(12)
    @add_to_playlist  = @playlist_key.playlist
  end

end
