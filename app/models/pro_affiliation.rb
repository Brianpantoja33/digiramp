class ProAffiliation < ActiveRecord::Base
  
  before_save :update_uuids
  before_destroy :update_uuids
  has_many :ipis
  
  def update_uuids
    AccountCache.update_pro_affilications_uuid
  end
  
  
end
