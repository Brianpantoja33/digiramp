class FbRecordingCommentWorker
  include Sidekiq::Worker
  
  def perform comment_id
    if share_on_facebook = ShareOnFacebook.find(comment_id)
      
      user      = share_on_facebook.user
      recording = share_on_facebook.recording
      
      if user.facebook_publish_actions
         user.facebook.put_wall_post(share_on_facebook.message,
                                      {
                                      "name" => "#{recording.title}",
                                      "link" => "http://www.digiramp.com/users/#{recording.user.slug}/recordings/#{recording.id}",
                                      "caption" => "#{user.name} reccomended a recording",
                                      "description" => "#{recording.comment}",
                                      "picture" => "#{recording.get_artwork}"
                                    })
      end
    end
  end

end