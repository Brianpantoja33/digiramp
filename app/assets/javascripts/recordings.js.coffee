ready = ->
  
  if $('.digiramp_player')[0]
    soundManager = recreateSoundManager()
    

  $('#playlist_recording_ids').chosen()
  
  

  
  #$('#recording_title').keyup ->
  #  #can_submit_text = $("#recording_title").val() != ''


      
  #$("input[type='checkbox']").click ->
  #  enable_next_button()
  $("input").on "ifToggled", (event) ->
    if $(".recording_acceptance_of_terms").length > 0
      enable_next_button()
    return

  $("#recording_file").change ->
    enable_next_button()
    
  

  $('#done').click ->
    $('#next_step').val('done');
    #alert 'fo'

        
    
  endless_pages()

  
$(document).ready(ready)
$(document).on('page:load', ready)




enable_next_button =() ->
  
  allowedExtension = ["mp3", "wave", "gif", "png"]
 
  enable_next =  $("input[type='checkbox']").prop( "checked" )
  if $("#recording_file").val() == ''
    enable_next = false

  if enable_next 
    $(".btn-next").removeAttr("disabled")
  else
    $(".btn-next").attr('disabled', 'disabled');
    


@endless_pages =() ->
  
  if $('.endless-pages').length
    if $('.pagination').length
      $(window).scroll ->
        url = $('.pagination .next a').attr('href')
        if url &&  $(window).scrollTop() > $(document).height() - $(window).height() - 200
          $('.pagination').text('...')
          $.getScript(url)
      $(window).scroll()
  