class ForumsController < ApplicationController
  before_action :set_forum, only: [:show, :edit, :update, :destroy]

  # GET /forums
  # GET /forums.json
  def index
    @forums = Forum.public_access
    @user   = current_user
  end

  # GET /forums/1
  # GET /forums/1.json
  def show
    @user   = current_user
  end

  # GET /forums/new
  def new
    @forum = Forum.new(user_id: current_user.id, created_at: Time.now)
    @user   = current_user
  end

  # GET /forums/1/edit
  def edit
    @user   = current_user
  end

  # POST /forums
  # POST /forums.json
  def create
    @forum = Forum.create(forum_params)
    redirect_to @forum

    #respond_to do |format|
    #  if @forum.save
    #    format.html { redirect_to @forum}
    #    format.json { render :show, status: :created, location: @forum }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @forum.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /forums/1
  # PATCH/PUT /forums/1.json
  def update
    respond_to do |format|
      if @forum.update(forum_params)
        format.html { redirect_to @forum, notice: 'Forum was successfully updated.' }
        format.json { render :show, status: :ok, location: @forum }
      else
        format.html { render :edit }
        format.json { render json: @forum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forums/1
  # DELETE /forums/1.json
  def destroy
    @forum_id = @forum.id
    @forum.destroy
    #respond_to do |format|
    #  format.html { redirect_to forums_url }
    #  format.json { head :no_content }
    #end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_forum
      @forum = Forum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def forum_params
      params.require(:forum).permit!
    end
end
