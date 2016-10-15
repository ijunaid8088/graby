moment = require 'moment'
moment_strf = require('moment-strftime')
module.exports =
  _process: (data) ->
    # console.log(data.schedule)
    # console.log moment_strf(data.from_date).strftime("%A")
    # console.log getDates(data.from_date, data.to_date)
    # console.log data.from_date
    from_date = data.from_date
    to_date = data.to_date
    interval = data.interval
    image_days = _handle_days data.schedule
    image_dates = _total_dates data.from_date, data.to_date


_handle_days = (schedule)->
	actual_days = ["Monday", "Tuseday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
	desired_days = []
	index = 0
	actual_days.forEach (day) ->
		if schedule[day] != ""
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
