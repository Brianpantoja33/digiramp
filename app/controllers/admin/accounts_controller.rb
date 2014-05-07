class Admin::AccountsController < ApplicationController
  
  before_filter :admins_only
  
  def index
    @accounts = Account.activated.search(params[:query]).order('lower(title) ASC').page(params[:page]).per(50)
  end
  
  def show
     @account = Account.cached_find(params[:id])
  end
  
  def new
    
  end
  
  def edit
    @account = Account.cached_find(params[:id])
  end
  
  def update
    @account = Account.cached_find(params[:id])
    params[:account][:rec_cache_version] = @account.rec_cache_version + 1 
    @account.update_attributes(account_params)
    
    redirect_to admin_account_path( @account)
  end
  
  def destroy
    @account = Account.cached_find(params[:id])
    flash[:info] = { title: "SUCCESS: ", body: "Account #{@account.title} deleted" }
    @account.destroy
    redirect_to admin_accounts_path
  end
  
  def delete_common_works
    @account = Account.cached_find(params[:account_id])
    @account.common_works.delete_all
    @account.works_cache_key += 1
    @account.save
    
    redirect_to :back
  end
  
  def delete_recordings
    @account = Account.cached_find(params[:account_id])
    @account.recordings.delete_all
    redirect_to :back
  end
  
  def delete_documents
    @account = Account.cached_find(params[:account_id])
    @account.attachments.delete_all
    redirect_to :back
  end
  
  private 
  
  def account_params
    params.require(:account).permit! if current_user.can_edit?
  end
end
