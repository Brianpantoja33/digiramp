class IpisController < ApplicationController

  def index
    return not_found unless @user = User.cached_find(params[:user_id])
    #@ipis = @user.ipis.where(show_credit_on_recordings: true)
    
    
    @user_credits = @user.user_credits.order(:title)
    
    
    
    
    
    #@common_work = CommonWork.cached_find(params[:common_work_id]) 
  end

  def show
  end

  #def new
  #  @common_work = CommonWork.cached_find(params[:common_work_id])
  #  @ipi = Ipi.new
  #end
  #
  #def create
  #  @common_work = CommonWork.cached_find(params[:common_work_id])
  #  @ipi = Ipi.create(ipi_params)
  #
  #  redirect_to account_common_work_ipis_path(@account, @common_work)
  #end
  #
  #def edit
  #  @common_work = CommonWork.cached_find(params[:common_work_id])
  #  @ipi = Ipi.cached_find(params[:id])
  #end
  #
  #def update
  #  @common_work = CommonWork.cached_find(params[:common_work_id])
  #  @ipi = Ipi.cached_find(params[:id])
  #  @ipi.update_attributes(ipi_params)
  #  redirect_to account_common_work_ipis_path(@account, @common_work)
  #end
  #
  #def destroy
  #  @common_work = CommonWork.cached_find(params[:common_work_id])
  #  @ipi = Ipi.cached_find(params[:id])
  #  @ipi.destroy
  #  redirect_to account_common_work_ipis_path(@account, @common_work)
  #end
  
private
  
  def ipi_params
     params.require(:ipi).permit!
  end
end
