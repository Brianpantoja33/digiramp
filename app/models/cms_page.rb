class CmsPage < ActiveRecord::Base
  belongs_to :user
  has_many :cms_sections
  has_many :comments,        as: :commentable,          dependent: :destroy
  
  after_commit :flush_cache

  def self.cached_find(id)
    Rails.cache.fetch([name, id]) { find(id) }
  end

private 

  def flush_cache
    Rails.cache.delete([self.class.name, id])
  end

end
