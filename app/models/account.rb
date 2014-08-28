class Account < ActiveRecord::Base
  include PublicActivity::Common
  # dont destroy user if account is deleted
  # the user might be active on another account
  belongs_to :user

  # used to contact
  has_many :clients
  
  # used as the basis for the CRM
  has_many :projects
  has_many :mail_campaigns
  has_many :client_groups
  
  # csv imports
  has_many :client_imports
  has_many :client_groups
  
  # image files uploaded
  has_many :artworks, dependent: :destroy
  
  # documents attached to the account
  has_many :documents, dependent: :destroy
  
  # !!! might be obsolete
  has_many :attachments, dependent: :destroy
  
  # Imported common works
  has_many :common_works_imports, dependent: :destroy
  
  # delete playlists when account is deleted
  has_many :playlists, dependent: :destroy
  
  # playlist keys
  has_many :playlist_keys
  
  # delete common_works when account is deleted
  has_many :common_works, dependent: :destroy
  
  # ipi codes connected to the account
  has_many :ipi_codes, as: :ipiable
  
  # !!! might be obsolete
  has_many :customer_event
  
  # delete recordings  when account is deleted
  has_many :recordings, dependent: :destroy
  has_many :import_batches, dependent: :destroy
  has_many :catalogs, dependent: :destroy
  
  # permissions keys for catalogs
  has_many :catalog_users

  #belongs_to :user
  #accepts_nested_attributes_for :user
  has_many :account_users, dependent: :destroy
  has_many :users, :through => :account_users
  
  has_many :opportunities, dependent: :destroy
  
  # access to playlists
  has_many :playlist_key_users
  
  has_many :emails
  
  # widgets
  has_many :widgets
  
  # statistick on playbacks
  has_many :playbacks
  
  # statistick on likes
  has_many :likes
                

  # account types
  ACCOUNT_TYPES =  ['Personal Account', 'Pro Account','Enterprise Account']
  
  
  # !!! might be obsolete
  scope :activated,  ->  { where( activated: true).order("title asc")  }
  
  # all accounts has to have a name
  validates_presence_of :title, :on => :update
  
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
  
  #before_destroy :delete_user
  #
  #def delete_user
  #  begin
  #    self.user.destroy
  #  rescue
  #  end
  #end
  #

  # make sure the administrator is the account owner up on creation
  #def initialize_account
  #  
  #  # this is how it should be
  #  self.administrator_id    = self.user_id
  #  
  #  # !!! but for now this is how it is
  #  if zebulon              = User.where(email: 'peter@musicintomedia.com').first
  #    self.administrator_id = zebulon.id
  #  end
  #end
  
  def set_uuid
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
      return User.cached_find(administrator_id)
    rescue
      puts '+++++++++++++++++++++++++++++++++++++++++++++++++'
      puts 'ERROR: Unable to find account administrator'
      puts 'In Account#administrator'
      puts '+++++++++++++++++++++++++++++++++++++++++++++++++'
      self.user
    end
  end
  
  # get the owner of the account
  def account_owner
    User.cached_find(user_id)
  end
  
  
  # call this from the ReassignAdministratorWorker
  # remove the old administrator and
  # initialize the new administrator
  # update the whitelist
  def reassign_administrator old_administrator_id

    puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>remove the old administrators account_user'
    #begin
      if old_administrator = AccountUser.where(user_id: old_administrator_id, account_id: self.id).first
        #old_administrator     = User.cached_find(old_administrator_id)
        
        if old_administrator_id == user_id
          # if the old administrator is the Account Owner
          # then downgrade premissions to the basic
          old_administrator.grand_basic_permissions
          
        elsif old_administrator.user.super?
          # if the old administrator is 'Super'
          # then grand all permissions
          old_administrator.role = 'Super User'
          old_administrator.save!
        else
          # if none of the above
          # then destroy the account user
          old_administrator.destroy! 
        end
      end
    #rescue
    #  puts '+++++++++++++++++++++++++++++++++++++++++++++++++'
    #  puts 'ERROR: Unable to find and destroy the old administrator'
    #  puts 'In Account#reassign_administrator'
    #  puts '+++++++++++++++++++++++++++++++++++++++++++++++++'
    #end
    
    new_administrator = AccountUser.where(user_id: administrator_id, account_id: self.id).first
    new_administrator.grand_all_permissions

  end
  
  def atached_ipi_codes
    IpiCode.where(account_id: self.id, ipiable_type: 'Account')
  end
  
  

  
  # remove a user from an account
  #def remove_user user_id
  #  if account_user = AccountUser.where(account_id: self.id, user_id: user_id).first
  #    # remove user
  #    account_user.destroy!
  #  else
  #    puts '+++++++++++++++++++++++++++++++++++++++++++++++++'
  #    puts 'ERROR: Unable to find account_user'
  #    puts 'In Account#remove_user'
  #    puts '+++++++++++++++++++++++++++++++++++++++++++++++++'
  #  end
  #end

  
  # add a use to an account
  def add_user user_id

  end

  # !!! might be obsolete
  def administrator_email=(administrator_email)
    
    if user = User.where(email: administrator_email).first
      user.invite_existing_user_to_account @account
    else
      user = User.create( name: administrator_email.downcase, 
                          email: administrator_email.downcase, 
                          role: 'Administrator', 
                          password: 'rOUhPgxQYzWtMvIsby3kET5aKcLSmd0w', 
                          password_confirmation: 'rOUhPgxQYzWtMvIsby3kET5aKcLSmd0w',
                          current_account_id: self.id)
      user.new_account_and_user_confirmation( @account )
    end
    
    self.administrator_id = user.id
    self.save!
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
  
  def self.cached_find(id)
    Rails.cache.fetch([name, id]) { find(id) }
  end

  

  def self.search( query)
    if query.present?
      return Account.search_account(query)
    else
      return all
    end
  end
  
  
  
  # make sure there is a account_user for the account_owner
  # and the account owners account_user has all permissions
  #def initialize_account_owner
  #  # secure there is a account_user for the account_owner
  #  account_user = get_account_user( self.user_id, "Account Owner" )
  #  
  #  if self.user_id == self.administrator_id                           
  #    account_user.grand_all_permissions
  #  else
  #    #!!! grand basic permissions
  #    account_user.grand_basic_permissions
  #  end
  #end
  #
  #
  #
  ## make sure there is a account_user for the administrator
  ## and the accounts administrator account_user has all permissions
  #def initialize_administrator
  #  # secure there is a account_user for the account_owner
  #  account_user = get_account_user( self.administrator_id, "Administrator" )                     
  #  account_user.grand_all_permissions
  #end
  #
  #
  ## after an account is created
  ## make sure there is a account_user for super users
  ## and the super users account_user has all permissions
  #def initialize_super_users
  #  User.supers.each do |super_user|
  #    super_account_user = get_account_user( super_user.id, "Super")
  #    super_account_user.grand_all_permissions
  #  end
  #end



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
  
  
  
  
  # !!! might be obsolete
  def repair_users

    # secure there is a account_user for the account_owner
    account_owner = AccountUser.where(account_id: self.id, user_id: self.user_id)
                               .first_or_create(account_id: self.id, user_id: self.user_id, role: 'Account Owner')  
    
    # grand all permissions to the account owner
    account_owner.grand_all_permissions
    
    # create an account user for each super user
    User.supers.each do |super_user|
      super_man = AccountUser.where(account_id: self.id, user_id: super_user.id)
                             .first_or_create(account_id: self.id, user_id: super_user.id, role: 'Super')  

    end

    
    # grand all permissions to administrators
    self.account_users.administrators.each do |account_user|
      account_user.grand_all_permissions
    end
    
    # grand all permissions to administrators
    self.account_users.supers.each do |account_user|
      account_user.grand_all_permissions
    end
    

    # account users with out any permissions should have no access
    self.account_users.each do |account_user|
      account_user.check_permissions
    end
    
    
  end
  
  
  
  # !!! might be obsolete
  def repair_recordings
  end
  
  # !!! might be obsolete
  def repair_works
    self.common_works.each do |work|
      work.update_completeness
    end
  end
  
  # !!! might be obsolete
  def repair_catalogs
  end
  
  def get_account_users
    user_ids = self.account_users.invited.pluck(:user_id)
    user_ids << self.user_id
    User.where(id: user_ids)
  end
  
  def get_users_and_supers
    users_and_supers = self.users + User.supers
    users_and_supers.uniq!
    users_and_supers
  end
  
  #def recording_ids
  #  
  #end
  
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
    Admin.cached_find(1).raise_accounts_version
  end

  #def init_activity_log
  #  ActivityLog.create!(account_id: id) unless ActivityLog.exists?(account_id: id)
  #end

end
