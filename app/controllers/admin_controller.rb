class AdminController < ApplicationController
  
  before_filter :admin_only
  def index
    @users = User.where(role: 'super')
    #where.('lower(email) ASC')
  end
  
  def flush_cache
    admin = Admin.first
    #logger.debug '--------------------------------------------------------------'
    admin.version += 1
    admin.save!
    Account.all.each do |account|
      account.rec_cache_version +=1
      account.save!
    end
    admin.flush_cache
    redirect_to :back
  end
end
