class Account::RecordingsController < ApplicationController
  include Transloadit::Rails::ParamsDecoder
  include RecordingsHelper
  include AccountsHelper
  before_action :access_account
  before_action :read_recording, only:[ :show, 
                                        :files, 
                                        :artwork,
                                        :new_artwork,
                                        :create_artwork,
                                        :download
                                      ]
  
  def index
    forbidden unless current_account_user && current_account_user.read_recording?
    @recordings     = Recording.not_in_bucket.account_search(@account, params[:query]).order('title asc').page(params[:page]).per(48)
    @show_more      = true
    @user           = current_user
  end

  def show
    
    forbidden unless current_account_user && current_account_user.read_recording
    @user           = current_user
    begin
      
      @recording      = Recording.cached_find(params[:id])
      
      @recording.create_activity(  :show, 
                                owner: current_user,
                            recipient: @recording,
                       recipient_type: @recording.class.name,
                           account_id: @account.id)
      rescue
        not_found
      end
      

  end
  
  def edit
    forbidden unless current_account_user && current_account_user.update_recording?
    @user           = current_user
    #@common_work    = CommonWork.find(params[:common_work_id])
    @recording              = Recording.find(params[:id])
    
    @recording.genre        = @recording.genre_tags_as_csv_string
    @recording.instruments  = @recording.instruments_tags_as_csv_string
    @recording.mood         = @recording.moods_tags_as_csv_string
    
    
    if params[:genre_category]
      redirect_to account_common_work_recording_genre_tags_path(@account, @common_work, @recording, genre_category: params[:genre_category])
    end
  end
  
  def new
    forbidden unless current_account_user && current_account_user.create_recording?
    @user           = current_user
    #@common_work    = CommonWork.cached_find(params[:common_work_id])
    @recording      = Recording.new
  end
  
  def create
    

    forbidden unless current_account_user && current_account_user.create_recording?

    result = TransloaditRecordingsParser.parse( params[:transloadit],  @account.id, false, @account.user_id)
    title = params[:recording][:title]
    
    if result[:recordings].size != 0
      
      result[:recordings].each do |recording|     
        current_user.create_activity(  :created, 
                                   owner: recording,
                               recipient: @user,
                          recipient_type: 'Recording',
                              account_id: current_user.account.id) 
                              
        
        
        recording.mount_common_work
        recording.title = title unless title == 'no title'
        
        if last_recording = @account.user.recordings.order('position asc').last
          begin
            recording.position = last_recording.position + 100
          rescue
          end
        end
        
        if recording.title.to_s == ''
          recording.title = File.basename(recording.original_file_name, ".*") 
        end
        recording.save
        recording.check_default_image
        recording.get_common_work.update_completeness
        @recording = recording
      end
      redirect_to edit_account_account_recording_basic_path(@account, @recording )
    else
      flash[:danger]      = "Please check it's a real audio file you are uploading" 
      redirect_to :back
    end

    
  end
  
  def update
    forbidden unless current_account_user && current_account_user.update_recording?
    #@common_work    = CommonWork.find(params[:common_work_id])
    @recording      = Recording.find(params[:id])
    
    
    params[:recording][:uuid] = UUIDTools::UUID.timestamp_create().to_s

    if @genre_category = params[:recording][:genre_category]
      params[:recording].delete :genre_category
    end

    if @recording.update_attributes(recording_params)
      
      
      @recording.create_activity(  :updated, 
                                owner: current_user,
                            recipient: @recording,
                       recipient_type: @recording.class.name,
                           account_id: @account.id)
                           
                           
                           
                           
      @recording.extract_genres
      @recording.extract_instruments
      @recording.extract_moods

      # artwork
      if params[:transloadit]
        if artworks = TransloaditImageParser.artwork( params[:transloadit], @account.id)
          # if there is no artwork file
          if artworks == []
            # if a drop down item is selected
            if params[:recording][:image_file_id].to_s != ''   
              artwork = Artwork.cached_find(params[:recording][:image_file_id])
              @recording.cover_art  = artwork.thumb
              @recording.save!
            end
          else
            # add the uploaded artwork
            # notice there is only one artwork file
            artworks.each do |artwork|
                                  
              RecordingItem.create( recording_id: @recording.id, 
                                    itemable_type: 'Artwork',
                                    itemable_id: artwork.id)
                                  
              @recording.cover_art      = artwork.thumb
              @recording.image_file_id  = artwork.id
              @recording.save!
            end
          end 
        end
      end

      if @recording.in_bucket?
        redirect_to account_account_recordings_bucket_path(@account, @recording )
      else
        #redirect_to :back
        @recording.get_common_work.update_completeness 
        redirect_to account_account_recording_path(@account, @recording )
      end
      
      #if @genre_category
      #  redirect_to edit_account_common_work_recording_path(@account, @common_work, @recording, genre_category: @genre_category )
      #else
      #  redirect_to account_common_work_recording_path(@account, @common_work, @recording, genre_category: @genre_category )
      #end

    else
      # jump back to recordings
      redirect_to_return_url account_account_recording_path(@account, @recording)
    end
  end

  
  def destroy
    forbidden unless current_account_user && current_account_user.delete_recording?
    if @recording  = Recording.cached_find(params[:id])
      common_work = @recording.get_common_work
      
      @recording.create_activity(  :deleted, 
                                owner: current_user,
                            recipient: @recording,
                       recipient_type: @recording.class.name,
                           account_id: @account.id)
                           
                           
                           
      #@recording.destroy!
      @recording.user_id    = User.system_user
      @recording.account_id = User.system_user.account_id
      @recording.privacy    = 'Only me'
      @recording.remove_from_collections
      @recording.save(validate: false)
      
      
      common_work.update_completeness if common_work
    end
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
      
      common_work.create_activity(  :created, 
                                owner: current_user,
                            recipient: common_work,
                       recipient_type: common_work.class.name,
                           account_id: @account.id)
 
      
      @recording.common_work_id = common_work.id
      @recording.cache_version += 1
      @recording.save
      @recording.get_common_work.update_completeness
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
      @recording.get_common_work.update_completeness
    end
    
  end

  def add_genre
    @blog           = Blog.recordings
    @recording      = Recording.find(params[:recording_id])
    if params[:recording]
      #@recording.category = params[:recording][:category]
      @recording.cache_version += 1
      @recording.save
      @recording.get_common_work.update_completeness
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
      @recording.get_common_work.update_completeness
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
  
  def find_in_bucket
    
  end
  
  def files
    forbidden unless current_account_user.read_recording
    #@recording      = Recording.cached_find(params[:id])
  end
  
  def documents
    forbidden unless current_account_user.read_recording
    @recording      = Recording.cached_find(params[:id])
  end
  
  def legal_documents
    forbidden unless current_account_user.read_recording
    @recording      = Recording.cached_find(params[:id])
  end
  
  def artwork
    forbidden unless current_account_user.read_recording
    @artwork = Artwork.new
  end
  
  
  def new_artwork
    forbidden unless current_account_user.read_recording
    @recording      = Recording.cached_find(params[:id])    
  end
  
  def create_artwork
    if params[:transloadit]
      if artworks = TransloaditImageParser.artwork( params[:transloadit], @account.id )
        artworks.each do |artwork|
          RecordingItem.create( recording_id: @recording.id, 
                                itemable_type: 'Artwork',
                                itemable_id: artwork.id)
        end
      end
    end
    redirect_to artwork_account_account_recording_path(@account, @recording)
  end
  
 
  
  # ====================================================
  # financial documents
  def financial_documents
    forbidden unless current_account_user.read_recording
    @recording      = Recording.cached_find(params[:id])
  end


 
  # this has to work with nginx
  # http://kovyrin.net/2010/07/24/nginx-fu-x-accel-redirect-remote/
  #def x_accel_url(url, file_name = nil)
  #  uri = "/internal_redirect/#{url.gsub('http://', '')}"
  #  uri << "?#{file_name}" if file_name
  #  return uri
  #end
  #
  #def download
  #  @recording                  = Recording.cached_find(params[:id])
  #  original_file_name          = Pathname.new(@recording.mp3).basename 
  #  
  #  
  #  headers['Content-Type']     = 'audio/mp3'
  #  headers['Cache-Control']    =  "private"
  #  headers['X-Accel-Redirect'] = x_accel_url(@recording.download_url, original_file_name)
  #  render :nothing => true
  #end
  
  # use the original file if it was a mp3
  # else use the converted file  
  #def download
  #  if current_user
  #    @recording                                = Recording.cached_find(params[:id])
  #
  #    original_file_name                        = Pathname.new(@recording.mp3).basename 
  #    response.headers['Content-Type']          = 'audio/mp3'
  #    response.headers['Content-Disposition']   = "attachment; filename=#{original_file_name}"
  #    response.headers['Cache-Control']         =  "private"
  #    #response.headers['X-Accel-Redirect']      = @recording.download_url
  #  end
  #  render :nothing=>true
  #end
  
  
  def download

    @recording                  = Recording.cached_find(params[:id])
    original_file_name          = Pathname.new(@recording.mp3).basename 
    data                        = open("#{@recording.download_url}") 
    
    respond_to do |format|
      format.html
      format.mp3 { 
        send_data(
          data.read, 
          disposition: "attachment; filename=#{original_file_name}",
          filename: original_file_name, 
          type: 'audio/mp3', 
          stream: 'true', 
          buffer_size: '4096' 
        )  
      }
    end
  end
  
  

  
private
  
  def recording_params
    params.require(:recording).permit( RecordingParams::PARAMS )
  end
  
  
end
