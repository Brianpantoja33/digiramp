class Admin::BlogsController < ApplicationController
  #respond_to :html, :xml, :json
  before_filter :admin_only
  before_filter :find_blog, only: [:edit, :update, :destroy, :show]
  #skip_before_filter :verify_authenticity_token, :only => [:destroy]
  #layout "core_admin"
  def index
    @blogs = Blog.search(params[:query]).order('title asc').page(params[:page]).per(12)
  end
  
  def show
    posts = @blog.blog_posts.order("position")
    
    @blog_posts = [[]]
    index = 0
    posts.each_with_index do |post, post_index|
      @blog_posts[index] << post
      if post_index % 2 == 1
        index += 1
        @blog_posts[index] = []
      end
    end

  end

  def new
    @blog = Blog.new

  end

  def edit

  end

  def create
    @blog = Blog.new(blog_params)
    if @blog.save!
      flash[:info] = { title: "SUCCESS: ", body: "#{@blog.title} Created" }
      redirect_to admin_blogs_path
    else
      render :new
    end
    
  end

  def update
    params[:blog][:version] = @blog.version + 1
    if @blog.update(blog_params)
      flash[:info] = { title: "SUCCESS: ", body: "#{@blog.title} updated" }
      redirect_to admin_blogs_path(page: params[:page])
    else
      render :edit
    end
    #redirect_to session[:go_to_after_update] || admin_blogs_path
  end

  def destroy
    flash[:info] = { title: "SUCCESS: ", body: "#{@blog.title} deleted" }
    @blog.destroy
    redirect_to admin_blogs_path(page: params[:page])
    #redirect_to admin_blogs_path
  end
  
private
  def find_blog
    @blog = Blog.find(params[:id])
  end

  def blog_params
    params.require(:blog).permit!  if current_user.can_edit?

  end

end