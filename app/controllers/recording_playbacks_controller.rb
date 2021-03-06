class RecordingPlaybacksController < ApplicationController
  before_action :get_user
  
  protect_from_forgery except: :index
  
  def index

    if @recording      = Recording.cached_find(params[:recording_id])

      if user_ids =  Playback.where(recording_id: @recording.id).pluck(:user_id)
        user_ids.uniq!
        @users = User.where(id: user_ids).page(params[:page]).per(4)
      end
    else
      params[:id] = params[:recording_id]
      not_found params
    end
    
  end
end
