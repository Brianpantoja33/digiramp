require 'json'
require 'uri'
require 'sendgrid-ruby'

class ClientInvitationMailer < ActionMailer::Base
  default from: "noreply@digiramp.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.client_invitation_mailer.send_with_avatar.subject
  #
  
  
  def import_form_linkedin client_import_id
    
    #client_import = ClientImport.cached_find(client_import_id)
    
    #clients = []
    
    #client_import.clients.each do |client|
    #  #ap client
    #end

  end
  
  # notice max 1000 at a time
  def invite_all_from_group client_group_id
    ap '+++++++++++++++++++++++++++++++ invite_all_from_group 6 +++++++++++++++++++++++++++++++++++++++++++'
    client_group    = ClientGroup.find(client_group_id)
    clients = 
    
    client_group.clients.in_groups_of(32) do |client_batch|
      invite_batch( client_group, client_batch)
      # take a break
      sleep 3
    end
    ap '+++++++++++++++++++++++++++++++++++++++ done ++++++++++++++++++++++++++++++++++++++++++++++++++++++'
  end
  
 
    
  def invite_batch client_group, client_batch
    

    
    @inviter        = client_group.user
    user_name       = @inviter.user_name
    
    @avatar_url     = ( URI.parse(root_url) + @inviter.image_url(:avatar_92x92) ).to_s
    
    invitations   = []
    emails        = []
    accept_urls   = []
    decline_urls  = []
    user_names    = []
    uniq_ids      = []
    index         = 0
    index         = 0
    
    
    # pack info into arays
    client_batch.each do |client|
      if client && email = client.email
        # Don't invite clients two times
        if client_has_received_email( client )
          ap '==================================='
          ap "client: #{client.email} has receiced email"
          ap '.'
        elsif invitation        = get_client_invitation( client )
          uniq_ids[index]       = invitation.id
          emails[index]         = invitation.email
          accept_urls[index]    = url_for( controller: '/contact_invitations', action: 'accept_invitation', contact_invitation_id:  invitation.uuid )
          decline_urls[index]   = url_for( controller: '/contact_invitations', action: 'decline_invitation', contact_invitation_id: invitation.uuid )
          user_names[index]     = user_name    
          index += 1
        end
      end
      
    end
    
    
    
    # prepre JSON
    x_smtpapi = { 
                  to: emails,
                  filters: { templates: {
                                       settings: {
                                                     enabled: 1,
                                                     template_id: template_id
                                                   }
                                      }
                           }, 
                   sub: {  
                           "--user_name--".to_sym =>    user_names,
                           "--accept_url--".to_sym =>   accept_urls,
                           "--decline_url--".to_sym =>  decline_urls,
                           "--avatar_url--".to_sym =>   decline_urls,
                           "--uniq_ids--".to_sym =>     uniq_ids,
                       
                        } ,
                   unique_args: 
                       {
                         uniq_ids: "--uniq_ids--"
                       }
                }
    
    # only send if there is someone to send to
    ap '---------------------------- emails ----------------------------------'
    ap emails
    # ap '---------------------------- user_names ----------------------------------'
    # ap user_names
    # ap '---------------------------- accept_urls ----------------------------------'
    # ap accept_urls
    # ap '---------------------------- decline_urls ----------------------------------'
    # ap decline_urls
    # ap '---------------------------- uniq_ids ----------------------------------'
    # ap uniq_ids
    ap '======================================================================'
    if emails.empty?
      Opbeat.capture_message("ClientInvitationMailer: no emails")
    else
      headder = JSON.generate(x_smtpapi)
      headers['X-SMTPAPI'] = headder
      #mail to: "info@digiramp.com", subject: "I'd like to add you my DigiRAMP music network"
    end
    
  end
  
  def client_has_received_email client
    ap "check user_id: #{client.user_id}, email: #{client.email}"
    ap ClientInvitation.where( user_id: client.user_id, email: client.email ).first
    
    invitation = ClientInvitation.where( user_id: client.user_id, email: client.email ).first
    invitation && !invitation.pending?
  end
  
  
  def get_client_invitation client
    ap 'get'
    ap ClientInvitation.where( user_id: client.user_id, email: client.email ).first
    
    ClientInvitation.where( user_id: client.user_id, email: client.email )
                    .first_or_create( user_id:    client.user_id,
                                      email:      client.email, 
                                      client_id:  client.id,
                                      account_id: client.account_id, 
                                      uuid:       UUIDTools::UUID.timestamp_create().to_s)

  end
  

  
  def send_one_with_avatar client_invitation_id
    @client_invitation    = ClientInvitation.cached_find(client_invitation_id)
    
    @client               = @client_invitation.client
    @inviter              = @client_invitation.user
    @accept_url           = url_for( controller: '/contact_invitations', action: 'accept_invitation', contact_invitation_id: @client_invitation.uuid )
    @decline_url          = url_for( controller: '/contact_invitations', action: 'decline_invitation', contact_invitation_id: @client_invitation.uuid )
    @avatar_url           = ( URI.parse(root_url) + @inviter.image_url(:avatar_92x92) ).to_s
    @uniq_ids             = @client_invitation.id
                
    x_smtpapi = { 
                  to: [@client.email],
                  filters: { templates: {
                                       settings: {
                                                     enabled: 1,
                                                     template_id: template_id
                                                   }
                                      }
                           }, 
                   sub: {  
                           "--user_name--".to_sym =>    [ @inviter.user_name.to_s ],
                           "--accept_url--".to_sym =>   [ @accept_url],
                           "--decline_url--".to_sym =>  [ @decline_url],
                           "--uniq_ids--".to_sym =>     [ @uniq_ids]
                        }, 
                  unique_args: 
                       {
                         uniq_ids: "--uniq_ids--"

                       }
    
                }
    
    headers['X-SMTPAPI'] = JSON.generate(x_smtpapi)
    


    mail to: "info@digiramp.com", subject: "I'd like to add you to my network of music professionals"
    
    #headers['X-SMTPAPI'] = '{ "to": ["max@digiramp.com", "max@pixelsonrails.com"]}'
    #
    #mail to: 'max@digiramp.com'
    
    
  end
    
  private
  
  def template_id
    #if Rails.env.production?
    #  return "9117870a-825a-4c81-8c04-8ff68d422ff7"
    #else
    #  return "1db1d5b2-d6d8-4f93-b1ff-9a8fa43457e8"
    #end
    "9117870a-825a-4c81-8c04-8ff68d422ff7"
  end
  

end
