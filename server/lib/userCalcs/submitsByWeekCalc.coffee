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
    res = Math.pow(2, v.major)
    if v.minor >= 'Б'
        res *= 1.2
    if v.minor >= 'В'
        res *= 1.2
    if v.minor >= 'Г'
        res *= 1.2
    return res

timeScore = (date) ->
    weeks = (new Date() - date)/MSEC_IN_WEEK
    #console.log weeks
    return Math.pow(0.5, weeks)

activityScore = (level, date) ->
    v = levelVersion(level)
    return v.major * timeScore(date)

@calculateRatingEtc = (user) ->
    thisStart = new Date(startDayForWeeks[user.userList])
    submits = Submits.findByUser(user._id).fetch()
    probSolved = {}
    weekSolved = {}
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
        if s.outcome != "AC"
            wasSubmits[week] = true
        else
            probSolved[s.problem] = true
            if !weekSolved[week]
                weekSolved[week] = 0
            weekSolved[week]++
            #console.log submitDate
            #console.log s.problem, level, levelScore(level), timeScore(submitDate), rating, activity
            rating += levelScore(level)
            activity += activityScore(level, submitDate)
    for week of wasSubmits
        if !weekSolved[week]
            weekSolved[week] = 0.5
    for w of weekSolved
        if w<0
            delete weekSolved[w]
    activity = Math.floor(activity)
    return {
        weekSolved: weekSolved
        rating: Math.floor(rating)
        activity: activity
        ratingSort: if activity > 0 then rating else -1/rating
    }
    
#Meteor.startup ->
#    Users.findById("207794").updateRatingEtc()