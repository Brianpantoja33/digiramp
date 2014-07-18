class Account::MusicSubmissionsController < ApplicationController
  before_action :set_music_request_and_submission, only: [:index, :show, :new, :edit, :update, :destroy]
  
  include AccountsHelper
  before_filter :access_account
  
  #def index
  #  @recordings     = Recording.account_search(@account, params[:query]).order('title asc').page(params[:page]).per(48)
  #end
  
  def new

  end
  
  
  
  def create
    #@music_submission = MusicSubmission.create(music_submission_params)
    #@music_submission = MusicSubmission.create( recording_id: params[:recording_id],
    #                                         music_request_id: params[:music_request_id]  
    #                                        )                 
    #redirect_to :back
  end
  
  def submit_recording
    ap params
    @music_submission = MusicSubmission.where( recording_id: params[:id],
                                                music_request_id: params[:music_request_id]  
                                              ).first_or_create( 
                                                recording_id: params[:id],
                                                music_request_id: params[:music_request_id]  
                                              )  
                                     
    @remove_button = "#add_to_request_#{params[:id]}"
    #puts '-----------------------------------------------------'
    #puts @add_to_request
    #@add_to_request
    #puts '-----------------------------------------------------'
  end

  def edit
  end

  def show
  end

  def destroy
  end

  def update

  end
  
private

  def music_submission_params
     params.require(:music_submission).permit!
  end
  
  # Use callbacks to share common setup or constraints between actions.
  def set_music_request_and_submission
    @music_request    = MusicRequest.cached_find(params[:music_request_id])
    @opportunity      = Opportunity.cached_find(params[:opportunity_id])
  end
  
  
end
