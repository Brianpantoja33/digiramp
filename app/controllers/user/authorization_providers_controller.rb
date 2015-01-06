class User::AuthorizationProvidersController < ApplicationController
  before_filter :access_user
  def index
    #@authorized = false
    #if current_user.id == @user.id || current_user.super?
    #  @authorized = true
    #end
  end
  
  def show
    ap params
    if params[:submit] == '0'
      authorization_provider = AuthorizationProvider.find(params[:id])
      authorization_provider.destroy
      render nothing: true
    else
      ap '====================== add ==============='
      redirect_to root_url format: "html"
    end
    
  end



  def destroy
    authorization_provider = AuthorizationProvider.find(params[:id])
    authorization_provider.destroy
    redirect_to user_user_authorization_providers_path(@user)
  end
end
