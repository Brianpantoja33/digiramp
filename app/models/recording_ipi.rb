class RecordingIpi < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :recording
  belongs_to :distribution_agreement
  validates :email, :role, :share, presence: true
  validates_formatting_of :email
  
  enum status: [ :pending, :confirmed, :accepted, :dismissed, :in_progress ]
  
  ROLES  = [ "Administrator",
             "Owner",
             "Artist",
             "Performers",
             "Producer",
             "Executive Producer",
             "Arranger",
             "Mixer",
             "Musician",
             "Vocalist",
             "Orchestrator",
             "Engineer",
             "Labels",
             "Production Companies",
             "Recording Studio",
             "Participant",
             "Sound Recording Copyright",
             "Representative",
             "Other"
           ]

  after_commit :flush_cache

  has_many :user_credits, as: :ipiable, dependent: :destroy
  #before_create :add_uuid
  #after_create :attach_user_credits
  #after_update :attach_user_credits
  #before_destroy :remove_user_credits
  
  # !!! self.recording.title is not a good ide
  #def attach_user_credits
  #  #if self.user
  #  #  UserCredit
  #  #  .where(ipiable_type: self.class.name, ipiable_id: self.id, user_id: self.user_id)
  #  #  .first_or_create(title: self.recording.title, 
  #  #                   ipiable_type: self.class.name, 
  #  #                   ipiable_id: self.id, 
  #  #                   user_id: self.user_id
  #  #                   )
  #  #end
  #  
  #end
  
  def configure_payment( price, rake, recording_uuid )
    #ap "recording_ipi / configure_payment "
    #ap "price: #{price}"
    #ap "rake: #{rake}"
    #ap "recording_uuid: #{recording_uuid}"
    
    if stakes = Stake.where(ip_uuid: self.uuid, ip_type: self.class.name)
      stakes.update_all(expired: true)
    end
    
    
    amount_in_cent =  rake * self.share * 0.01
    amount_in_pct  =  amount_in_cent /  price
    

    begin
      
      if stake = Stake.find_by( account_id:         self.account_id,
                                asset_id:           recording_uuid,
                                asset_type:         'Recording',
                                ip_uuid:            self.uuid,
                                ip_type:            self.class.name
                               )
                               
        stake.update(
                     split:               amount_in_pct,
                     flat_rate_in_cent:   amount_in_cent,
                     currency:            'usd',
                     email:               self.user.email,
                     unassigned:          false,
                     expired:             false
                     
                     )
      else
        stake = Stake.create(  account_id:          self.account_id,
                               user_id:             self.user_id,
                               asset_id:            recording_uuid,
                               asset_type:          'Recording',
                               ip_uuid:             self.uuid,
                               ip_type:             self.class.name,
                               split:               amount_in_pct,
                               flat_rate_in_cent:   amount_in_cent,
                               currency:            'usd',
                               email:               self.user.email,
                               unassigned:          false,
                               expired:             false
                            )
      end
      
      #ap stake
    rescue => e
      ErrorNotification.post_object 'RecordingIpi#configure_payment', e
      
    end
    
    
  end
  
  #def remove_user_credits
  #  begin
  #    UserCredit.where( ipiable_id: self.id, ipiable_type: self.class.name).destroy_all
  #  rescue
  #  end
  #end
  
  def full_name
    if self.user
      user.full_name
    else
      self.name
    end
  end
  
  def document_count
    0
  end
  
  #def add_uuid
  #  self.uuid = UUIDTools::UUID.timestamp_create().to_s
  #end
  #
  #def attach_user
  #  if user         = User.where(email: self.email).first
  #    self.user_id = user.id
  #    self.name    = user.user_name
  #  end
  #end
  
  def send_confirmation_request
    send_confirmation_email
    send_confirmation_notification
  end
  
  def self.cached_find(id)
    begin
      return Rails.cache.fetch([name, id]) { find(id) }
    rescue 
      return nil
    end
  end
  
  
  
private

  def send_confirmation_email
    RecordingIpiMailer.delay.recording_ipi_confirmation_email self.id
  end
  
  def send_confirmation_notification
    # if self.user
    #'send_confirmation_notification'
  end


  def flush_cache
    Rails.cache.delete([self.class.name, id])
  end
end




