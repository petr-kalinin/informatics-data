Template.solvedByWeekHeader.helpers
    weekSet: ->
        thisStart = new Date(startDayForWeeks["" + @userList])
        now = new Date()
        nowWeek = Math.floor((now - thisStart) / MSEC_IN_WEEK)
        [0..nowWeek]

    admin: ->
        isAdmin()

        
Template.oneWeekHeader.helpers
    weekHeader: ->
        thisStart = new Date(startDayForWeeks[@userList])
        startDay = new Date(+thisStart + MSEC_IN_WEEK * @weekNumber)
        endDay = new Date(+startDay + MSEC_IN_WEEK - 1)
        startDay.getUTCDate() + "-" + endDay.getUTCDate() + "." + (endDay.getUTCMonth()+1)
            
