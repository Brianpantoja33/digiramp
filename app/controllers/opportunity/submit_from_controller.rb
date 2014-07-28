class Opportunity::SubmitFromController < ApplicationController
  
  include OpportunitiesHelper
  before_filter :access_opportunity
  
  def index
    
    @music_request   = MusicRequest.cached_find(params[:music_request_id])
  end
end
