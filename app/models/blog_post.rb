class BlogPost < ActiveRecord::Base
  

  
  
  belongs_to :blog
  has_many :comments, as: :commentable
  #attr_accessible :author, :body, :crop_params, :image, :image_title, :title, :blog_id, :identifier, :position, :link, :teaser, :layout
  validates_presence_of :title
  serialize :crop_params, Hash
  mount_uploader :image, ArtworkUploader
  #include ImageCrop
  LAYOUTS = %w[layout_6_6  layout_4_8 layout_3_9 layout_12]
  after_commit :flush_cache
  

  
  def self.cached_find(identifier , blog)
    Rails.cache.fetch([name, identifier , blog.id]) { BlogPost.where(identifier: identifier, blog_id: blog.id)\
                                                             .first_or_create(identifier: identifier, blog_id: blog.id, title: identifier, body: '') }
  end
  
private

  def flush_cache
    Rails.cache.delete([self.class.name, identifier, blog.id])
  end
end
