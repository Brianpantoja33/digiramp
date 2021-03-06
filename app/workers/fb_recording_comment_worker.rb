class FbRecordingCommentWorker
  include Sidekiq::Worker
  
  def perform share_on_facebook_id
    # I added a lot of error test here
    if share_on_facebook = ShareOnFacebook.cached_find(share_on_facebook_id)
      
      if user     = share_on_facebook.user
        recording = share_on_facebook.recording
        if facebook = user.facebook
          # error here, no user
          facebook.put_wall_post(share_on_facebook.message,
                                     {
                                     "name" => "#{recording.title}",
                                     "link" => "http://www.digiramp.com/users/#{recording.user.slug}/recordings/#{recording.id}",
                                     "caption" => "#{user.user_name} recommended a recording",
                                     "description" => "#{recording.comment}",
                                     "picture" => "#{recording.get_artwork}"
                                   })
        else
          #ap 'no facebook'
        end
      else
        #ap 'no user'
      end  
    end
  end

end