@calculateSubmitsByWeek = (user) ->
    thisStart = new Date(startDayForWeeks[user.userList])
    submits = Submits.findByUser(user._id).fetch()
    probSolved = {}
    weekSolved = {}
    wasSubmits = {}
    for s in submits
        if probSolved[s.problem]
            continue
        submitDate = new Date(s.time)
        if (submitDate < thisStart)
            continue
        week = Math.floor((submitDate - thisStart) / MSEC_IN_WEEK)
        if s.outcome != "AC"
            wasSubmits[week] = true
        else
            probSolved[s.problem] = true
            if !weekSolved[week]
                weekSolved[week] = 0
            weekSolved[week]++
    for week of wasSubmits
        if !weekSolved[week]
            weekSolved[week] = 0.5
    return weekSolved
    
Meteor.startup ->
    Users.findById("64352").updateSolvedByWeek()