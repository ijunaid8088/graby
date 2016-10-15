sendAJAXRequest = (settings) ->
  token = $('meta[name=" csrf-token"]')
  if token.size() > 0
    headers =
      "X-CSRF-Token": token.attr("content")
    settings.headers = headers
  xhrRequestChangeMonth = jQuery.ajax(settings)
  true

onProceed = ->
  $("#extract-now").on "click", ->

    onError = (data) ->
      console.log data

    onSuccess = (data) ->
      console.log(data)

    settings =
      error: onError
      success: onSuccess
      cache: false
      data: {}
      dataType: "json"
      type: "POST"
      url: "/extractors"

    sendAJAXRequest(settings)

window.initializeMain = ->
  onProceed()
