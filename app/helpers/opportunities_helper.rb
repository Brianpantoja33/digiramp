module OpportunitiesHelper
  
  def access_opportunity

    return forbidden if current_user.nil?
    begin
      opportunity_id      = params[:opportunity_id] || params[:id]
      @opportunity        = Opportunity.cached_find(opportunity_id)
      @opportunity_users  = OpportunityUser.where(opportunity_id: @opportunity.id, user_id: current_user.id)
      forbidden unless @opportunity_users
      not_fount unless @account         = current_user.account
      return
    rescue
      
    end
    not_found
  end
  
  
end
