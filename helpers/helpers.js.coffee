moment = require 'moment'
moment_strf = require('moment-strftime')
dontEnv = require('dotenv').config()
fs = require 'fs'
request = require 'request'
http = require('http')
delayed = require("delayed");
image_downloader = require('image-downloader')

module.exports =
  _process: (data) ->
    console.log "Start Date - End Date"
    console.log data.from_date, data.to_date
    console.log "Schedule"
    console.log data.schedule
    console.log "Total Valid days"
    console.log _total_dates(data.from_date, data.to_date)
    console.log "Recording Days"
    console.log _handle_days(data.schedule)
    console.log "Recording Dates"
    console.log _valid_dates(_total_dates(data.from_date, data.to_date), _handle_days(data.schedule))
    # console.log moment_strf(data.from_date).strftime("%A")
    # console.log _total_dates(data.from_date, data.to_date)
    valid_recording_dates = _valid_dates(_total_dates(data.from_date, data.to_date), _handle_days(data.schedule))
    interval = data.interval
    _create_url(valid_recording_dates, data.schedule, interval)


_handle_days = (schedule)->
  actual_days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
  desired_days = []
  index = 0
  actual_days.forEach (day) ->
    if schedule[day].length < 1
    else
      desired_days[index] = day
      index += 1
  desired_days

_total_dates = (startDate, stopDate) ->
  dateArray = new Array
  currentDate = startDate
  while currentDate <= stopDate
    dateArray.push currentDate
    currentDate = currentDate.addDays(1)
  dateArray

Date::addDays = (days) ->
  date = new Date(@valueOf())
  date.setDate date.getDate() + days
  date

_valid_dates = (dates, days) ->
  validDates = new Array
  index = 0
  dates.forEach (date) ->
    days.forEach (day) ->
      if moment_strf(date).strftime("%A") == day
        validDates[index] = date
        index += 1
      else
        #dont do anything here
  validDates

_create_url = (dates, schedule, interval) ->
  interval = 1
  _urls = new Array
  _final_uris = new Array
  date_index = 0
  start_val = 0
  end_val = 1
  dates.forEach (date) ->
    # times = schedule[moment_strf(date).strftime("%A")]
    time_range = schedule[moment_strf(date).strftime("%A")]
    times = time_range[date_index].split "-"
    start_time = times[start_val].split ":"
    end_time = times[end_val].split ":"
    starting_hour = parseInt(start_time[start_val], 10)
    starting_minutes = parseInt(start_time[end_val], 10)
    ending_hour = parseInt(end_time[start_val], 10)
    ending_minutes = parseInt(end_time[end_val], 10)
    starting_recording_date = new Date(date)
    starting_recording_date.setHours(starting_hour);
    starting_recording_date.setMinutes(starting_minutes);
    starting_recording_date.setSeconds(0);
    ending_recodring_date = new Date(date)
    ending_recodring_date.setHours(ending_hour);
    ending_recodring_date.setMinutes(ending_minutes);
    ending_recodring_date.setSeconds(0);
    looping_time_in_sec = ending_recodring_date - starting_recording_date
    console.log starting_recording_date, ending_recodring_date
    # for i in [0...looping_time_in_sec] by interval
    #   if starting_recording_date <= ending_recodring_date
    #     ending_url = moment_strf(starting_recording_date).strftime("%Y/%m/%d/%H/%M_%S_000.jpg")
    #     _urls.push ending_url
    #     starting_recording_date.setSeconds(starting_recording_date.getSeconds() + interval)
        # console.log ending_recodring_date, starting_recording_date
      # ...
  # _urls.forEach (url) ->
  #   _final_uris.push process.env.SEAWEED + "/florida-usa/snapshots/recordings/" + url

  # console.log "Final", _final_uris
  # takeMeFromWeedAndPushMeOnDP(_final_uris)
    # console.log moment_strf(starting_recording_date).strftime("%Y/%m/%d/%H/%M_%S_000")

    # console.log ending_recodring_date, starting_recording_date


takeMeFromWeedAndPushMeOnDP = (urls) ->
  console.log "nothinf"
  # urls.forEach (uri) ->
  #   options = 
  #     url: uri
  #     dest: 'pics/'
  #     done: (err, filename, image) ->
  #       if err
  #         console.log err
  #       console.log 'File saved to', filename
  #       return
  #   image_downloader options

Array::remove = ->
  what = undefined
  a = arguments
  L = a.length
  ax = undefined
  while L and @length
    what = a[--L]
    while (ax = @indexOf(what)) != -1
      @splice ax, 1
  this

# download = (uri, filename, callback) ->
#   request.head uri, (err, res, body) ->
#     console.log 'content-type:', res.headers['content-type']
#     console.log 'content-length:', res.headers['content-length']
#     delayed.delay (->
#       request(uri).pipe(fs.createWriteStream(filename)).on 'close', callback
#     ), 1000
#     return
#   return
