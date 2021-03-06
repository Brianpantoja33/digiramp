class Admin::UserMetricsController < ApplicationController
  before_action :admin_only
  def index
    
    
    @want_to_promote_my_music                = UserConfiguration.where(i_want_to_promote_my_music:  true).count
    @want_to_sell_music                      = UserConfiguration.where(i_want_to_sell_music:  true).count
    @want_to_get_my_music_into_films_and_tv  = UserConfiguration.where(i_want_to_get_my_music_into_films_and_tv:  true).count
    @want_to_find_and_listen_to_music        = UserConfiguration.where(i_want_to_find_and_listen_to_music:  true).count
    @want_to_sell_goods                      = UserConfiguration.where(i_want_to_sell_goods:  true).count
    @want_to_offer_services                  = UserConfiguration.where(i_want_to_offer_services:  true).count
    @want_to_collaborate                     = UserConfiguration.where(i_want_to_collaborate:  true).count
    @want_to_manage_users_and_catalogs       = UserConfiguration.where(i_want_to_manage_users_and_catalogs:  true).count
    @want_to_build_custom_web_pages          = UserConfiguration.where(i_want_to_build_custom_web_pages:  true).count
    @dont_ask_me_again                       = UserConfiguration.where(dont_ask_me_again:  true).count
    
    @has_uploaded_recordings                 = User.where(has_recordings: true).count
    @provide_to_opportunity                  = User.where(provide_to_opportunity: true).count
    @review_opportunity                      = User.where(review_opportunity: true).count
    
    @follow_other_users                      = User.where(follow_other_users:    true).count
    @has_liked_recordings                    = User.where(has_liked_recordings: true).count
    
    @liked_recordings                        = Like.count
    @has_liked_a_user                       = User.where(has_liked_a_user: true).count
    
    @has_wrote_a_recording_comment          = User.where(has_wrote_a_recording_comment: true).count
    @has_wrote_a_user_comment               = User.where(has_wrote_a_user_comment: true).count
    @has_wrote_a_playlist_comment           = User.where(has_wrote_a_playlist_comment: true).count
    @user_configuration_configured          = User.where(user_configuration_configured: true).count
    @has_invited_friends                    = UserConfiguration.where(has_invited_friends: true).count
    
    @has_connected_facebook                 = AuthorizationProvider.where(provider: 'facebook').count
    @has_connected_twitter                  = AuthorizationProvider.where(provider: 'twitter').count
    @has_connected_gplus                    = AuthorizationProvider.where(provider: 'gplus').count
    @has_connected_linkedin                 = AuthorizationProvider.where(provider: 'linkedin').count
    @has_connected_stripe                   = AuthorizationProvider.where(provider: 'stripe_connect').count
    
    @not_set_publishing                     = User.where("status = ?" , 0).count
    @not_uploaded_digiral_signature         = User.where(digital_signature_uuid: nil).count
    
    
   
  end
end
