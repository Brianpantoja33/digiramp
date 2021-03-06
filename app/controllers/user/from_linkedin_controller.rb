class User::FromLinkedinController < ApplicationController
  before_action :access_user
  include AccountsHelper
  
  def new
    @client_import = ClientImport.new
  end

  def create
    params[:client_import][:source] = 'linkedin'
    if @client_import = ClientImport.create(client_import_params)
      ClientLinkedinImportWorker.perform_async( @client_import.id, current_user.email )
      flash[:info] = "Import started, this might take a few moments" 
      redirect_to user_user_control_panel_index_path(@user)
    else
      
    end
  end
  
  def index
    if super?
      @client_imports = @user.client_imports
    else
      forbidden
    end
  end
  
  
  
  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def client_import_params
    params.require(:client_import).permit(:account_id,:user_uuid,:file,:user_id,:source)
  end
end

