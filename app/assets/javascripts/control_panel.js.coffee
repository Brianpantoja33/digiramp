ready = ->
  $(".mail_subscribtion").toggles(
    text:
      on: "Yes" 
      off: "No")

  
  $(".mail_subscribtion").on "toggle", (e, active) ->
    id = $(this).attr 'id'
    user_id = $(this).attr 'user_id'
    if active
      $.getScript("/user/users/" + user_id + '/mail_subscribtions/' +  id + '/?submit=1')
    else
      $.getScript("/user/users/" + user_id + '/mail_subscribtions/' +  id + '/?submit=0')
    return
    
    
  #==========================
  $(".facebook-toggle").toggles(
    text:
      on: "On" 
      off: "Off") 
      
  $(".facebook-toggle").on "toggle", (e, active) ->
    user_id                   = $(this).attr 'user_id'
    if active
       #$.getScript("/user/users/" + user_id + "/authorization_providers/facebook/?submit=1")
      wait_for_authorization()
      window.location.replace("/auth/facebook")
    else
      authorization_provider_id = $(this).attr 'authorization_provider_id'
      $.getScript("/user/users/" + user_id + "/authorization_providers/"  + authorization_provider_id + '/?submit=0')


  #==========================
  $(".twitter-toggle").toggles(
    text:
      on: "On" 
      off: "Off")
  
  $(".twitter-toggle").on "toggle", (e, active) ->
    user_id                   = $(this).attr 'user_id'
    if active
       #$.getScript("/user/users/" + user_id + "/authorization_providers/facebook/?submit=1")
      wait_for_authorization()
      window.location.replace("/auth/twitter")
    else
      authorization_provider_id = $(this).attr 'authorization_provider_id'
      $.getScript("/user/users/" + user_id + "/authorization_providers/"  + authorization_provider_id + '/?submit=0')
     

  #==========================
  $(".linkedin-toggle").toggles(
    text:
      on: "On" 
      off: "Off")
  
  $(".linkedin-toggle").on "toggle", (e, active) ->
    user_id                   = $(this).attr 'user_id'
    if active
       #$.getScript("/user/users/" + user_id + "/authorization_providers/facebook/?submit=1")
      wait_for_authorization()
      window.location.replace("/auth/linkedin")
    else
      authorization_provider_id = $(this).attr 'authorization_provider_id'
      $.getScript("/user/users/" + user_id + "/authorization_providers/"  + authorization_provider_id + '/?submit=0')
  
  #==========================
  $(".google-plus-toggle").toggles(
    text:
      on: "On" 
      off: "Off")
  
  $(".google-plus-toggle").on "toggle", (e, active) ->
    user_id                   = $(this).attr 'user_id'
    if active
       #$.getScript("/user/users/" + user_id + "/authorization_providers/facebook/?submit=1")
      wait_for_authorization()
      window.location.replace("/auth/gplus")
    else
      authorization_provider_id = $(this).attr 'authorization_provider_id'
      $.getScript("/user/users/" + user_id + "/authorization_providers/"  + authorization_provider_id + '/?submit=0')
  
  #==========================
  $(".stripe-toggle").toggles(
    text:
      on: "On" 
      off: "Off")
  
  $(".stripe-toggle").on "toggle", (e, active) ->
    user_id                   = $(this).attr 'user_id'
    if active
       #$.getScript("/user/users/" + user_id + "/authorization_providers/facebook/?submit=1")
      wait_for_authorization()
      window.location.replace("/auth/stripe_connect")
    else
      authorization_provider_id = $(this).attr 'authorization_provider_id'
      $.getScript("/user/users/" + user_id + "/authorization_providers/"  + authorization_provider_id + '/?submit=0')
      
      
  
  
  
  
  #=========================
  $(".show-recordings").toggles(
    text:
      on: "On" 
      off: "Off")
  

  
$(document).ready(ready)
$(document).on('page:load', ready)

@wait_for_authorization =() ->
  $.blockUI css:
    border: "none"
    padding: "15px"
    backgroundColor: "#000"
    "-webkit-border-radius": "10px"
    "-moz-border-radius": "10px"
    opacity: .5
    color: "#fff"

  setTimeout($.unblockUI, 20000)
  
  