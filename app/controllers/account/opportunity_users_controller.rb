class Account::OpportunityUsersController < ApplicationController
  before_action :set_opportunity, only: [:show] 
  include AccountsHelper
  before_action :access_account

  # GET /opportunities
  # GET /opportunities.json
  def index
    #forbidden unless current_account_user.read_opportunity
    #@opportunities = @account.opportunities
    forbidden unless current_account_user.update_opportunity
    @opportunity = Opportunity.cached_find(params[:opportunity_id])
    @user        = current_user
    @opportunity_invitation = OpportunityInvitation.new(reviewer: true)

  end
  
  
  #
  ## GET /opportunities/1
  ## GET /opportunities/1.json
  def show
    @opportunity_user = OpportunityUser.cached_find(params[:id])
    @user             = current_user
    @playlists        = current_user.playlists
  end
  #
  ## GET /opportunities/new
  #def new
  #  forbidden unless current_account_user.create_opportunity
  #  @opportunity = Opportunity.new
  #end
  #
  ## GET /opportunities/1/edit
  def edit
    forbidden unless current_account_user.update_opportunity
    @opportunity          = Opportunity.cached_find(params[:opportunity_id])
    @opportunity_user     = OpportunityUser.cached_find(params[:id])
    @user                 = current_user
  end
  #
  ## POST /opportunities
  ## POST /opportunities.json
  #def create
  #  
  #end

  # PATCH/PUT /opportunities/1
  # PATCH/PUT /opportunities/1.json
  def update
    forbidden unless current_account_user.update_opportunity
    
    @opportunity          = Opportunity.cached_find(params[:opportunity_id])
    @opportunity_user     = OpportunityUser.cached_find(params[:id])
    
    @opportunity_user.update(opportunity_user_params)
    
    @opportunity_user.create_activity(   :updated, 
                                   owner: current_user,
                               recipient: @opportunity_user.user,
                          recipient_type: @opportunity_user.user.class.name,
                              account_id: @opportunity_user.user.account.id,
                                  params: {    
                                            opportunity_id: @opportunity.id,
                                    opportunity_user_email: @opportunity_user.user.email
                                            
                                          }
                                      ) 
                                      
    redirect_to account_account_opportunity_opportunity_users_path(@account, @opportunity)                             
  end
  
 
  # DELETE /opportunities/1
  # DELETE /opportunities/1.json
  def destroy
    @opportunity          = Opportunity.cached_find(params[:opportunity_id])
    @opportunity_user     = OpportunityUser.cached_find(params[:id])
    @opportunity_user_id  = @opportunity_user.id
    
    @opportunity_user.create_activity(   :destroyed, 
                                   owner: current_user,
                               recipient: @opportunity_user.user,
                          recipient_type: @opportunity_user.user.class.name,
                              account_id: @opportunity_user.user.account.id,
                                  params: {    
                                            opportunity_id: @opportunity.id,
                                    opportunity_user_email: @opportunity_user.user.email
                                            
                                          }
                                      ) 
                                      
    
    @opportunity_user.destroy!
    #redirect_to account_account_opportunity_path(@account, @opportunity)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_opportunity
      @opportunity = Opportunity.cached_find(params[:opportunity_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def opportunity_user_params
      params.require(:opportunity_user).permit!
    end
end
