module.exports =
  _process: (data) ->
    # console.log(data.schedule)
    # console.log _handle_days(data.schedule)
    console.log data.from_date
    from_date = data.from_date
    to_date = data.to_date
    interval = data.interval
    image_days = _handle_days data.schedule


_handle_days = (schedule)->
	actual_days = ["Monday", "Tuseday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
	desired_days = []
	index = 0
	actual_days.forEach (day) ->
		if schedule[day] != ""
			desired_days[index] = day
			index += 1
	desired_days

