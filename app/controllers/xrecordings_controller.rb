class RecordingsController < ApplicationController
  include Transloadit::Rails::ParamsDecoder
  include RecordingsHelper
  include AccountsHelper
  before_filter :access_account
  #before_filter :read_recording, only:[:show]
  
  def index
    forbidden unless current_account_user.read_recording?
    @recordings     = Recording.account_search(@account, params[:query]).order('title asc').page(params[:page]).per(48)
    @show_more      = true
    
  end

  def show
    logger.debug'-----------------------------------------------------'
    logger.debug current_account_user.inspect
    forbidden unless current_account_user.read_recording
    
    @common_work    = CommonWork.cached_find(params[:common_work_id])
    @recording      = Recording.cached_find(params[:id])


  end
  
  def edit
    forbidden unless current_account_user.update_recording?
    @common_work    = CommonWork.find(params[:common_work_id])
    @recording      = Recording.find(params[:id])
    
    @recording.genre        = @recording.genre_tags_as_csv_string
    @recording.instruments  = @recording.instruments_tags_as_csv_string
    @recording.mood         = @recording.moods_tags_as_csv_string
    
    #@recording.copy_genre_tags_in_to_genre_string
    if params[:genre_category]
      redirect_to account_common_work_recording_genre_tags_path(@account, @common_work, @recording, genre_category: params[:genre_category])
    end
  end
  
  def new
    forbidden unless current_account_user.create_recording?
    @common_work    = CommonWork.cached_find(params[:common_work_id])
    @recording      = Recording.new
  end
  
  def create
    forbidden unless current_account_user.create_recording?
    @common_work           = CommonWork.cached_find(params[:common_work_id])
    begin
      TransloaditParser.add_to_common_work params[:transloadit], @common_work.id, @account.id
      flash[:info]      = { title: "Success", body: "Recording added to Common Work" }
      redirect_to account_work_work_recordings_path(@account, @common_work )
    rescue
      flash[:danger]      = { title: "Unable to create Recording", body: "Please check if you selected a valid file" }
      redirect_to new_account_common_work_recording_path(@account, @common_work )
    end
    
  end
  
  def update
    forbidden unless current_account_user.update_recording?
    @common_work    = CommonWork.find(params[:common_work_id])
    @recording      = Recording.find(params[:id])
    
    
    params[:recording][:uuid] = UUIDTools::UUID.timestamp_create().to_s

    if @genre_category = params[:recording][:genre_category]
      params[:recording].delete :genre_category
    end

    if @recording.update_attributes(recording_params)
      @recording.extract_genres
      @recording.extract_instruments
      @recording.extract_moods

      #if image_file = ImageFile.where(id: @recording.image_file_id).first
      #  @recording.cover_art = image_file.thumb
      #  @recording.save
      #end
      
      @recording.common_work.update_completeness
      
      if @genre_category
        redirect_to edit_account_common_work_recording_path(@account, @common_work, @recording, genre_category: @genre_category )
      else
        redirect_to account_common_work_recording_path(@account, @common_work, @recording, genre_category: @genre_category )
      end

    else
      # jump back to recordings or common work
      redirect_to_return_url account_common_work_recording_path(@account, @common_work, @recording)
    end

  end

  
  def destroy
    @recording = Recording.find(params[:id])
    common_work = @recording.common_work
    @recording.destroy
    common_work.update_completeness
    # jump back to recordings or common work
    redirect_to_return_url account_account_recordings_path( @account, page: params[:page], query: params[:query])
  end
  
  def upload_completed
    @recording      = Recording.find(params[:recording_id])
    @recording.extract_metadata

    if @recording.common_work.nil? && !CommonWork.account_search(@account, @recording.title).empty? 
      # If the common_work is not set and there is common_works with the same name as the recording
      redirect_to edit_account_recording_common_work_path(@account, @recording)
    elsif @recording.common_work.nil?
      # else if the common_work is not set and there is no common_works with the same title
      common_work = CommonWork.create(account_id: @recording.account_id, title: @recording.title, lyrics: @recording.lyrics)
      @recording.common_work_id = common_work.id
      @recording.cache_version += 1
      @recording.save
      @recording.common_work.update_completeness
    end                        
  end
  
  
  
  
  
  def select_category
    @blog               = Blog.recordings
    @recording          = Recording.find(params[:recording_id])

    if params[:recording]
      @recording.title        = params[:recording][:title]      if params[:recording][:title]
      @recording.has_lyrics   = params[:recording][:has_lyrics] if params[:recording][:has_lyrics]
      @recording.explicit     = params[:recording][:explicit]   if params[:recording][:explicit]
      #@recording.category     = params[:recording][:category]   if params[:recording][:category]
      @recording.cache_version += 1
      @recording.save
      @recording.common_work.update_completeness
    end
    
  end

  def add_genre
    @blog           = Blog.recordings
    @recording      = Recording.find(params[:recording_id])
    if params[:recording]
      #@recording.category = params[:recording][:category]
      @recording.cache_version += 1
      @recording.save
      @recording.common_work.update_completeness
    end
    @blog               = Blog.recordings
    

    
  end


  def add_mood
    @blog           = Blog.recordings
    @recording      = Recording.find(params[:recording_id])
    if params[:recording]
      #@recording.category = params[:recording][:category]
      @recording.cache_version += 1
      @recording.save
      @recording.common_work.update_completeness
    end
    @blog               = Blog.recordings
  end

  def add_instruments

  end

  def add_lyrics

  end
  def add_description

  end

  def add_more_meta_data

  end
  def overview

  end
  
  #def download
  #  @recording = Recording.cached_find(params[:id])
  #  
  #  original_file_name = 'Audiofile'
  #  if @recording.mp3
  #    original_file_name = Pathname.new(@recording.mp3).basename 
  #  else
  #    original_file_name = @recording.title
  #  end
  #  send_file @recording.mp3 , :type=>"audio/mp3", :filename => original_file_name
  #end
  
  #def download
  #  @recording = Recording.cached_find(params[:id])
  #  AWS.config({
  #    access_key_id: "AKIAIVATNWTNMQZKK2VA",
  #    secret_access_key: "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"
  #  })
  #
  #  send_data( 
  #    AWS::S3.new.buckets["digiramp"].objects["0.mp3"].read, {
  #      filename: "0.mp3", 
  #      type: "audio/mp3", 
  #      disposition: 'attachment', 
  #      stream: 'true', 
  #      buffer_size: '4096'
  #    }
  #  )
  #end
  
  
  
private
  
  def recording_params
    params.require(:recording).permit!
  end
  
  
end