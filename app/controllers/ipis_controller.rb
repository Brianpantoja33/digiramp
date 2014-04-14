class IpisController < ApplicationController
  before_filter :there_is_access_to_the_account
  def index
    @common_work = CommonWork.cached_find(params[:common_work_id]) 
  end

  def show
  end

  def new
    @common_work = CommonWork.cached_find(params[:common_work_id])
    @ipi = Ipi.new
  end
  
  def create
    @common_work = CommonWork.cached_find(params[:common_work_id])
    @ipi = Ipi.create(ipi_params)

    redirect_to edit_account_common_work_ipi_path(@account, @common_work, @ipi)
  end

  def edit
    @common_work = CommonWork.cached_find(params[:common_work_id])
    @ipi = Ipi.cached_find(params[:id])
  end
  
  def update
    @common_work = CommonWork.cached_find(params[:common_work_id])
    @ipi = Ipi.cached_find(params[:id])
    @ipi.update_attributes(ipi_params)
    redirect_to account_common_work_ipis_path(@account, @common_work)
  end
  
private
  
  def ipi_params
     params.require(:ipi).permit!
  end
end
