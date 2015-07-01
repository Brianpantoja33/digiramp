class Account < ActiveRecord::Base
  include PublicActivity::Common
  has_paper_trail
  # dont destroy user if account is deleted
  # the user might be active on another account
  #belongs_to :user
  
  belongs_to :user
  validates :user_id, uniqueness: true

  # used to contact
  has_many :clients,                dependent: :destroy
  
  # used as the basis for the CRM
  has_many :projects,                dependent: :destroy
  has_many :mail_campaigns,          dependent: :destroy
  has_many :client_groups,           dependent: :destroy
  
  # csv imports
  has_many :client_imports,          dependent: :destroy
  has_many :client_groups,           dependent: :destroy
  
  has_many :coupons,                dependent: :destroy
  has_many :invoices,               dependent: :destroy
  has_many :playlist_emails,        dependent: :destroy
  #has_many :products,               class_name: 'Shop::Product', dependent: :destroy
  #has_many :shop_stripe_transfers,  dependent: :destroy
  
  has_many :stakes,                 dependent: :destroy
  has_many :recording_ipis,         dependent: :destroy
  
  
  # image files uploaded
  has_many :artworks,     dependent: :destroy
  
  # documents attached to the account
  has_many :documents,    dependent: :destroy
  
  # !!! might be obsolete
  has_many :attachments,  dependent: :destroy
  
  # Imported common works
  has_many :common_works_imports, dependent: :destroy
  
  # delete playlists when account is deleted
  has_many :playlists,    dependent: :destroy
  
  # playlist keys
  has_many :playlist_keys
  
  # delete common_works when account is deleted
  has_many :common_works, dependent: :destroy
  
  # ipi codes connected to the account
  has_many :ipi_codes, as: :ipiable
  
  # !!! might be obsolete
  has_many :customer_event,                dependent: :destroy
  
  # don't delete recordings  when account is deleted
  has_many :recordings
  
  has_many :import_batches, dependent: :destroy
  has_many :catalogs,       dependent: :destroy
  
  # permissions keys for catalogs
  has_many :catalog_users,       dependent: :destroy

  #belongs_to :user
  #accepts_nested_attributes_for :user
  has_many :account_users,  dependent: :destroy
  #has_many :users, :through => :account_users
  
  has_many :opportunities,  dependent: :destroy
  
  # access to playlists
  has_many :playlist_key_users,       dependent: :destroy
  
  has_many :emails,       dependent: :destroy
  
  # widgets
  has_many :widgets,       dependent: :destroy
  
  # statistick on playbacks
  has_many :playbacks,       dependent: :destroy
  has_many :recording_views,       dependent: :destroy
  
  # statistick on likes
  has_many :likes,       dependent: :destroy
  
  has_many :campaigns,          dependent: :destroy
  has_many :campaign_events,       dependent: :destroy
  has_many :client_invitation,  dependent: :destroy
  has_many :contracts,          dependent: :destroy
  
  has_many :comments,    as: :commentable,     dependent: :destroy
  
  has_many :creative_projects,  dependent: :destroy
  
  has_many :subscriptions,  dependent: :destroy
  
  belongs_to :account_feature
  
  has_many :products,         class_name: 'Shop::Product', dependent: :destroy
  has_many :stripe_transfers, class_name: 'Shop::StripeTransfer', dependent: :destroy
  
  #has_many :registrations
                

  # account types
  ACCOUNT_TYPES =  ['Social','Pro','Business', 'Enterprise']
  
  
  # !!! might be obsolete
  scope :activated,  ->  { where( activated: true).order("title asc")  }
  
  # all accounts has to have a name
  validates_presence_of :title, :on => :update
  validates_with AccountValidator, fields: [:stripe_flat_transfer_fee, :stripe_percent_transfer_fee]
  validates_formatting_of :contact_email, :using => :email
  
  
  # default name for autogenerated accounts
  # !!! should never be shown in the front end
  SECRET_NAME = "opjeKDV79Ml4"
  
  # !!! should be swaped with s3 storage
  mount_uploader :logo, LogoUploader
  
  # clear memcache
  after_commit :flush_cache
  
  
  # search against
  include PgSearch
  pg_search_scope :search_account, against: [ :title, 
                                              :description, 
                                              :contact_first_name, 
                                              :contact_last_name, 
                                              :contact_email, 
                                              :fax,
                                              :street_address,
                                              :city,
                                              :state,
                                              :postal_code
                                            ], :using => [:tsearch]
  
  
  # make sure the administrator is the account owner up on creation
  #before_create :initialize_account
  
  # update the uuid so all cached segments expires
  before_save :set_uuid
  
  before_destroy :cleanup_migrations
  
  def cleanup_migrations
    unlocked_creative_projects           = self.creative_projects.where(locked: false)
    unlocked_creative_projects.destroy_all
    
    self.products.update_all(account_id: nil)
    #self.recordings.update_all(account_id: nil)
    #self.stripe_transfers.update_all(account_id: nil)
  end
  
  def update_expiration_date
    if last_registration = self.registrations.last
      self.expiration_date = last_registration.expiration_date
      save!
    end
  end
  
  def current_plan
    # can return nil
    return current_subscription.plan if current_subscription
  end
  
  def current_subscription
    # latest subscription not expired
    subscription = subscriptions.last
  end
  
  
  
  
  
  #def subscribtion_price
  #  
  #  ap self.account_type
  #  
  #  if account_feature = AccountFeature.where(account_type: self.account_type).first
  #    return account_feature.subscription_fee
  #  else
  #    return 0
  #  end
  #  
  #end
  
  
  
  def transfer_codes=(uuids)
    
  end
  
  def transfer_codes
  end
  
  def set_uuid
    self.title = self.title.strip
    self.uuid = UUIDTools::UUID.timestamp_create().to_s
  end
  

  

  # !!! might be obsolete
  def has_no_name?
    title == Account::SECRET_NAME
  end
  
  # !!! might be obsolete
  def owner_has_no_name?
    account_owner.name == account.user.email
  end
  
  
  
  # !!! might be obsolete
  def show_welcome_message?
    account_owner.show_welcome_message
  end
  
  def administrator
    begin
      return User.cached_find(self.administrator_id)
    rescue
      puts '+++++++++++++++++++++++++++++++++++++++++++++++++'
      puts 'ERROR: Unable to find account administrator'
      puts 'In Account#administrator'
      puts '+++++++++++++++++++++++++++++++++++++++++++++++++'
      if self.user
        return self.user
      end
    end
  end
  
  # get the owner of the account
  def account_owner
    User.cached_find(user_id)
  end
  
  
  
  
  def atached_ipi_codes
    IpiCode.where(account_id: self.id, ipiable_type: 'Account')
  end
  
  
  # add a use to an account
  def add_user user_id

  end

  # !!! might be obsolete
  def administrator_email=(administrator_email)
    
    console.log '+++++++++++++++++++++++++++++++++++++++++++++++++'
    console.log 'ERROR: User#administrator_email'
    console.log 'not supported emailer broken'
    console.log '+++++++++++++++++++++++++++++++++++++++++++++++++'
    
  end
  
  # !!! might be obsolete
  def administrator_email
    administrators_account_user.user.email.downcase
  end
  
  include Rails.application.routes.url_helpers
  def link
    case account_type.to_s
    when 'supervisor'
      supervisor_account_home_index_path(self)
    else
      account_path(self)
    end
  end
  

  # get the administrators account user
  def administrators_account_user
    
    if User.exists?(self.administrator_id)
    
      if account_user = AccountUser.cached_where( self.id, self.administrator_id )
        return account_user
      else
        # better error handling here ! make account owner administrator!!!
        account_user = get_account_user(self.administrator_id, 'Administrator')
      end
    else
      puts '+++++++++++++++++++++++++++++++++++++++++++++++++'
      puts 'ERROR: Unable to find administrator'
      puts 'In Account#administrators_account_user'
      puts '+++++++++++++++++++++++++++++++++++++++++++++++++'
      #<<<<<<<<<<<<<<<< ADD FLASH EMSSAGE, RESET ADMINISTRATR, POST MESSAGO IN ADMIN SECTION
      #self.administrator_id 
    end
  end
  
  def owners_account_user
    return AccountUser.where(user_id: user_id, account_id: self.id).first
  end
  
  def self.cached_find(id)
    Rails.cache.fetch([name, id]) { find(id) }
  end
  
  # !!! not needed anymore
  #def count_users
  #  self.user_count = self.account_users.count
  #  self.save!
  #end

  

  def self.search( query)
    if query.present?
      return Account.search_account(query)
    else
      return all
    end
  end
  


  # get a account user
  # if the account user is not found
  # create a new one 
  def get_account_user user_id, role
    AccountUser.where( account_id: self.id, 
                       user_id: user_id
                      )
               .first_or_create( account_id: self.id, 
                                 user_id: user_id, 
                                 role: role
                                )                           
  end
  
  def can_be_accessed_by user_id
    return true if User.cached_find(user_id).super?
    AccountUser.exists?( account_id: self.id, user_id: user_id)
  end
  
  
  def update_account_type
    update_account_users
  end
  
  def update_account_users

    self.account_users.each do |account_user|
      update_permissions_on account_user
    end
    
    unless self.account_type == 'Social'
      administrators_account_user.grand_pro_permissions
    end

  end
  
  def update_permissions_on account_user
    if self.account_type == 'Social'
      account_user.remove_pro_permissions unless account_user.user.super?

    end
  end
  

  def reassign_administrator old_administrator_id

    if old_administrator = AccountUser.where(user_id: old_administrator_id, account_id: self.id).first
      #old_administrator     = User.cached_find(old_administrator_id)
      
      if old_administrator_id == user_id
        # if the old administrator is the Account Owner
        # then downgrade premissions to the basic
        old_administrator.remove_admin_features
      else
        # else destroy the account user
        old_administrator.destroy! 
      end
    end


    administrator     = User.cached_find(administrator_id)
    new_administrator = AccountUser.where(user_id: administrator.id, account_id: self.id)
                                    .first_or_create(user_id: administrator.id, account_id: self.id)
    
    new_administrator.grand_pro_permissions

  end
  
  
  def is_administrated
    self.administrator_id  != self.user_id
  end


  def get_account_users
    User.where(id: self.account_user_ids).pluck(:user_name, :id)
  end
  
  # !!! something strange here
  def get_users_and_supers
    #users_and_supers = self.users + User.supers
    #users_and_supers.uniq!
    #users_and_supers
    self.users
    # why noy
    # users ?
  end
  

  def update_assets_count
    self.catalogs.each do |catalog|
      catalog.update_assets_count
    end
  end
  
  def self.cached_find(id)
    begin
      return Rails.cache.fetch([name, id]) { find( id) }
    rescue
      return nil
    end
  end


  
private

  def flush_cache
    Rails.cache.delete([self.class.name, id])
    #Admin.cached_find(1).raise_accounts_version
  end

  #def init_activity_log
  #  ActivityLog.create!(account_id: id) unless ActivityLog.exists?(account_id: id)
  #end

end
