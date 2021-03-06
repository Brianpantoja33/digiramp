class PlaylistsController < ApplicationController
  #include AccountsHelper
  #before_action :access_account
  before_action :get_user
  #before_action :authorized, except: [:show, :index]
  
  def index
    #@playlists = @user.playlists
    #if @authorized  
    #  @recordings =   Recording.recordings_search(@user.recordings, params[:query]).page(params[:page]).per(48)
    #else
    #  @recordings =  @user.recordings.published.recordings_search(@user.recordings, params[:query]).page(params[:page]).per(48)
    #end
  end

  def show
    begin
      @playlist     = Playlist.cached_find(params[:id])
      #@recordings   = @playlist.recordings
    rescue
      not_found params
    end
  end
  
  def new
    forbidden unless @user.permits?( current_user )
    @playlist = Playlist.new
    @playlist.downloadkey = UUIDTools::UUID.timestamp_create().to_s
    @recordings   = @user.recordings.not_in_bucket
  end
  
  def create
    forbidden unless @user.permits?( current_user )
    if @playlist = Playlist.create(playlist_params)
      @playlist.check_default_image
      redirect_to user_playlist_path( @user, @playlist)
      
    else
      render new
    end
  end

  def edit
    @playlist = Playlist.cached_find(params[:id])
    @recordings   = @user.recordings.not_in_bucket
  end

  def update
    
    @playlist = Playlist.cached_find(params[:id])
    
    
    if @playlist.update_attributes(playlist_params)
      @playlist.check_default_image
      #redirect_to user_playlist_path( @user, @playlist )
      @recordings   = @playlist.recordings
      
      redirect_to user_playlist_path( @user, @playlist )
    else
      redirect_to edit_user_playlist_path( @user, @playlist )
    end
  end
  
  def destroy
    @playlist_id = params[:id]
    @playlist = Playlist.cached_find(@playlist_id)
    @playlist.destroy
    
    #redirect_to user_playlists_path( @user )
  end
  
private 

  #def authorized
  #  forbidden unless @authorized
  #end

  def playlist_params
     params.require(:playlist).permit!
  end
end
