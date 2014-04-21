class UploadRecordingsController < ApplicationController
  include Transloadit::Rails::ParamsDecoder
  
  before_filter :there_is_access_to_the_account

  def new
    @recording        = Recording.new
  end
  
  # called when an  import is completed
  def create
    @import_batch         = TransloaditParser.parse_recordings( params[:transloadit], @account.id )
    flash[:info]          = { title: "SUCCESS: ", body: "Import completed" }
    redirect_to account_import_batch_path(@account,   @import_batch)
  end
  
  def extrace_tags_for genre_string
    genres = genre_string.split(',')
  end
  
  def index
    
  end
  

  def edit
    @recording              = Recording.cached_find(params[:id])
    @common_work            = CommonWork.cached_find(params[:common_work_id])
  end
  
  def update
    flash[:info]            = { title: "SUCCESS: ", body: "Audio file uploaded" }
    @recording              = Recording.cached_find(params[:id])
    @common_work            = CommonWork.cached_find(params[:common_work_id])
    transloadets            = TransloaditParser.update(@recording, params[:transloadit] )
    redirect_to edit_account_common_work_recording_path(@account, @common_work, @recording )
  end
  

end
