problemLevelCache = {}

findProblemLevel = (problem) ->
    if problemLevelCache[problem]
        return problemLevelCache[problem]
    contests = Contests.findAll().fetch()
    resLevel = ""
    for c in contests
        for p in c.problems
            if (p._id == problem) and (c.level > resLevel)
                resLevel = c.level
    problemLevelCache[problem] = resLevel
    return resLevel

levelVersion = (level) ->
    if (level.slice(0,3) == "reg")
        major = 3
        minor = 'А'
    else
        major = parseInt(level.slice(0, -1))
        minor = level[level.length - 1]
    return {
        major: major,
        minor: minor
    }

levelScore = (level) ->
    v = levelVersion(level)
    res = Math.pow(LEVEL_RATING_EXP, v.major)
    minorExp = Math.pow(LEVEL_RATING_EXP, 0.25)
    if v.minor >= 'Б'
        res *= minorExp
    if v.minor >= 'В'
        res *= minorExp
    if v.minor >= 'Г'
        res *= minorExp
    return res

timeScore = (date) ->
    weeks = (new Date() - date)/MSEC_IN_WEEK
    #console.log weeks
    return Math.pow(WEEK_ACTIVITY_EXP, weeks)

activityScore = (level, date) ->
    v = levelVersion(level)
    return Math.sqrt(v.major) * timeScore(date)

@calculateRatingEtc = (user) ->
    thisStart = new Date(startDayForWeeks[user.userList])
    submits = Submits.findByUser(user._id).fetch()
    probSolved = {}
    weekSolved = {}
    weekOk = {}
    wasSubmits = {}
    rating = 0
    activity = 0
    for s in submits
        if probSolved[s.problem]
            continue
        level = findProblemLevel(s.problem)
        if (level == "")
            continue
        submitDate = new Date(s.time)
        week = Math.floor((submitDate - thisStart) / MSEC_IN_WEEK)
        wasSubmits[week] = true
        if s.outcome == "AC"
            probSolved[s.problem] = true
            if !weekSolved[week]
                weekSolved[week] = 0
            weekSolved[week]++
            #console.log submitDate, s.problem, level
            #console.log levelScore(level), timeScore(submitDate), activityScore(level, submitDate)
            #console.log "=", rating, activity
            rating += levelScore(level)
            activity += activityScore(level, submitDate)
        else if s.outcome == "OK"
            if !weekOk[week]
                weekOk[week] = 0
            weekOk[week]++
    for week of wasSubmits
        if !weekSolved[week]
            weekSolved[week] = 0.5
    for w of weekSolved
        if w<0
            delete weekSolved[w]
    for w of weekOk
        if w<0
            delete weekOk[w]
    activity *= (1 - WEEK_ACTIVITY_EXP) # make this averaged
    return {
        solvedByWeek: weekSolved
        okByWeek: weekOk
        rating: Math.floor(rating)
        activity: activity
        ratingSort: if activity > ACTIVITY_THRESHOLD then rating else -1/(rating+1)
        active: if activity > ACTIVITY_THRESHOLD then 1 else 0
    }
    
#Meteor.startup ->
#    Users.findById("82325").updateRatingEtc()