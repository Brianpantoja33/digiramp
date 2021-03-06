#require 'pusher'
#
#Pusher.app_id   = '78910'
#Pusher.key      = 'd70ad0d20fdef342dd05'
#Pusher.secret   = '608220ad093a78b7f95d'











class Catalog::CatalogsController < ApplicationController
  
  include AccountsHelper
  include CatalogsHelper
  
  before_action :access_account
  before_action :access_catalog, only: [:show, 
                                        :update, 
                                        :edit, 
                                        :move, 
                                        :copy_code, 
                                        :find_common_work_in_collection
                                        
                                       ]

  def index

    forbidden unless current_user && current_user.has_access_to_cattalogs_on( @account )

    

  end

  def show

  end

  def new
    forbidden unless current_account_user.createx_catalog
    @catalog = Catalog.new
  end
  
  def create
    @catalog = Catalog.create(catalog_params)
    
    @catalog.create_activity(  :created, 
                       owner: current_user,
                   recipient: @catalog,
              recipient_type: @catalog.class.name,
                  account_id: @catalog.account_id)
                  
    redirect_to catalog_account_catalog_path( @account, @catalog)
  end

  def edit
    @catalog = Catalog.cached_find(params[:id])
    
  end
  
  def update
    #@catalog = Catalog.cached_find(params[:id])
    @catalog.update_attributes(catalog_params)
    
    @catalog.create_activity(  :updated, 
                       owner: current_user,
                   recipient: @catalog,
              recipient_type: @catalog.class.name,
                  account_id: @catalog.account_id)
                  
  
    redirect_to catalog_account_catalog_path( @account, @catalog)
  end
  
  def move
    forbidden unless  current_user.can_administrate @account
  end
  
  def find_common_work_in_collection
    forbidden unless current_account_user.read_common_work?
    
    @common_works  = CommonWork.find_from_collection(@account, @catalog, params[:query]).order('title asc').page(params[:page]).per(32)
    
  end
  
  

  
  def generate_code
    @catalog            = Catalog.cached_find(params[:catalog_id])
    
    if params[:catalog][:movable] == '1'
      if @catalog.move_code.to_s == ''
        @catalog.move_code  = UUIDTools::UUID.timestamp_create().to_s
      end
      @catalog.movable      = true
      @catalog.include_all  = params[:catalog][:include_all] == '1'
      @catalog.save!
      redirect_to :back
    else
      @catalog.move_code    = ''
      @catalog.movable      = false
      @catalog.include_all  = false
      @catalog.save!
      redirect_to catalog_account_catalog_path( @account, @catalog) 
    end
    
  end
  
  #def get_code
  #  @catalog            = Catalog.cached_find(params[:catalog_id])
  #  @catalog.move_code  = UUIDTools::UUID.timestamp_create().to_s
  #  @catalog.movable    = true
  #  @catalog.save!
  #  redirect_to account_catalog_move_path @account, @catalog
  #end
  
  def destroy
    @catalog = Catalog.find(params[:id])
    
    @catalog.create_activity(  :destroyed, 
                       owner: current_user,
                   recipient: @catalog,
              recipient_type: @catalog.class.name,
                  account_id: @catalog.account_id)
                  
                  
    @catalog.destroy
    redirect_to catalog_account_catalogs_path( @account)
  end
  
private

  def catalog_params
    params.require(:catalog).permit!
  end
  
  
end
