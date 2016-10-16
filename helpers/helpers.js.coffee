moment = require 'moment'
moment_strf = require('moment-strftime')

module.exports =
  _process: (data) ->
    # console.log "Start Date - End Date"
    # console.log data.from_date, data.to_date
    # console.log "Schedule"
    # console.log data.schedule
    # console.log "Total Valid days"
    # console.log _total_dates(data.from_date, data.to_date)
    # console.log "Recording Days"
    # console.log _handle_days(data.schedule)
    # console.log "Recording Dates"
    # console.log _valid_dates(_total_dates(data.from_date, data.to_date), _handle_days(data.schedule))
    # console.log moment_strf(data.from_date).strftime("%A")
    # console.log _total_dates(data.from_date, data.to_date)
    valid_recording_dates = _valid_dates(_total_dates(data.from_date, data.to_date), _handle_days(data.schedule))
    interval = data.interval


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
        console.log "Am valid day", moment_strf(date).strftime("%A")
  validDates

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
