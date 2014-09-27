class PlaylistsController < ApplicationController
  #include AccountsHelper
  #before_filter :access_account
  before_filter :get_user, only: [:create, :show, :index, :edit, :update, :new]
  def index
    #@playlists = @user.playlists
    #if @authorized  
    #  @recordings =   Recording.recordings_search(@user.recordings, params[:query]).page(params[:page]).per(48)
    #else
    #  @recordings =  @user.recordings.published.recordings_search(@user.recordings, params[:query]).page(params[:page]).per(48)
    #end
  end

  def show
    @playlist     = Playlist.cached_find(params[:id])
  end
  
  def new
    @playlist = Playlist.new
    @recordings   = @user.recordings.not_in_bucket
  end
  
  def create
    if @playlist = Playlist.create(playlist_params)
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
      ap @playlist
      redirect_to user_playlist_path( @user, @playlist )
    else
      render :edit
    end
  end
  
  def destroy
    @playlist = Playlist.cached_find(params[:id])
    @playlist.destroy

    redirect_to user_playlists_path( @user )
  end
  
private  

  def playlist_params
     params.require(:playlist).permit!
  end
end
