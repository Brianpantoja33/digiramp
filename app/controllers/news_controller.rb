class NewsController < ApplicationController
 
  def index
    @news_blog        =  Blog.cached_find('news blog')
    if current_user
      current_user.news_count  =  Blog.news_count
      current_user.save(validate: false)
      @user = current_user
    end
  end
end
