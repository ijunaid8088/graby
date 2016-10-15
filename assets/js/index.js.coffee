sendAJAXRequest = (settings) ->
  token = $('meta[name=" csrf-token"]')
  if token.size() > 0
    headers =
      "X-CSRF-Token": token.attr("content")
    settings.headers = headers
  xhrRequestChangeMonth = jQuery.ajax(settings)
  true

onSignIn = ->
  $("#sign-me-in").on "click", ->
    username = $("#username").val()
    password = $("#password").val()
    checkInputs(username, password)

    onError = (data) ->
      console.log data

    onSuccess = (data) ->
      console.log(data)

    data = {}
    data.username = username
    data.password = password
    settings =
      error: onError
      success: onSuccess
      cache: false
      data: data
      dataType: "json"
      type: "POST"
      url: "/login_enpoint"

    sendAJAXRequest(settings)

checkInputs = (username, password) ->
  if $("#username").val() is ""
    $.notify 'Username is empty'
    return
  if $("#password").val() is ""
    $.notify 'Password is empty'
    return

window.initializeMain = ->
  onSignIn()