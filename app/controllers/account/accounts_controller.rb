class Account::AccountsController < ApplicationController
  
  include AccountsHelper
  before_action :access_account
  
  
  def show
    forbidden current_account_user 
    session[:account_id] = params[:id]
    @user = @account.user
    
  end
  
  def edit
    forbidden current_account_user.user_id == @account.user_id
    @account = Account.cached_find(params[:id])
    @user = @account.user
  end
  
  def update
    forbidden current_account_user.user_id == @account.user_id
    @account  = Account.cached_find(params[:id])
    @account.update_attributes(account_params)
  
    redirect_to account_account_path(  @account)
  
  end
  
  def find_recording_in_bucket
    
  end
  
  def recordings
    
  end
  
  def legal_documents
    forbidden current_account_user.read_legal_document?
    @files = @account.documents.legal
  end
  
  def financial_documents
    forbidden current_account_user.read_financial_document?
    @files = @account.documents.financial
  end
  
  def artwork
    
  end
  
  def files
    @files = @account.documents.files
  end
  
  def destroy
    
    @account = Account.cached_find(params[:id])
    @account.create_activity(  :destroyed, 
                          owner: current_user,
                      recipient: @account,
                 recipient_type: @account.class.name)
              
    
    
    if @account.user
      user = @account.user
      user.create_activity(  :destroyed, 
                            owner: current_user,
                        recipient: user,
                   recipient_type: user.class.name,
                       account_id: @account.id)
                   
      
      
      user.flush_auth_token_cache(cookies[:auth_token])
      cookies.delete(:auth_token)
      cookies.delete(:user_id)
      
      
      user.destroy! 
      
      
      
    end 
    @account.destroy!   
    
    
    redirect_to root_path   
    
    
  end


  private
    
  def account_params
    params.require(:account).permit(AccountParams::PUBLIC_PARAMS)
  end

end
