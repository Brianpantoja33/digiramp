class Publisher < ActiveRecord::Base
  has_paper_trail
  enum status: [ :pending, :confirmed, :dismissed ]
  
  
  default_scope -> { order('created_at ASC') }
  #scope :first, -> { order("created_at").first }
  #scope :last, -> { order("created_at DESC").first }
  
  
  validates :legal_name , :email, presence: true
  
  #has_many :user_publishers, dependent: :destroy
  #has_many :users,   :through => :user_publishers 
  
  has_many :ipi_publishers
  #has_many :ipis,   :through => :ipi_publishers 
  has_many :ipis,   :through => :publishing_agreements 
  
  has_many :common_work_ipis
  
  
  has_many :publishing_agreements
  
  belongs_to :account
  belongs_to :user
  has_many   :user_publishers, dependent: :destroy
  belongs_to :pro_affiliation
  
  has_one :address
  accepts_nested_attributes_for :address
  include AddressMix
  
  

  
  validates_with PublisherValidator, fields: [:email] 
  #validates :email, presence: true, uniqueness: true
  # all users can create publishers
  # sometime they create a user on behalf of someone else
  #after_create :create_user_publisher
  after_commit :flush_cache
  
  before_destroy :sanitize_relations
  
  def sanitize_relations
    
    if self.user_publishers
      user_publishers.destroy_all
    end
    
    
    common_work_ipis.update_all(publisher_id: nil)
  end
  
  def user_publishing_agreement user_id
    
    if publishing_agreemet = publishing_agreements.find_by(user_id: user_id, )
      return publishing_agreemet
    end
    
  end

  def self.cached_find(id)
    Rails.cache.fetch([name, id]) { find(id) }
  end
  
  def add_user_email!
    if self.personal_publisher
      user_email = UserEmail.where(email: self.email, user_id: self.user_id)
                            .first_or_create(email: self.email, user_id: self.user_id)
    end
  end
  
  def confirmed_publishing?(published_user_id)
    if ipis.find_by(user_id: published_user_id)
      if _publishing_agreement = user_publishing_agreement( published_user_id )
        return _publishing_agreement.ok
      end
    end
    false
  end
  


  private 

  def flush_cache
    Rails.cache.delete([self.class.name, id])
  end

  
  #def create_user_publisher
  #  UserPublisher.where(publisher_id: self.id, user_id: self.user_id)
  #               .first_or_create(publisher_id: self.id, user_id: self.user_id)
  #end
  

  
  
  
end
