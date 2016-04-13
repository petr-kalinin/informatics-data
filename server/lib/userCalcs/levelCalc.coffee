@calculateLevel = (user, lastDate) ->
    for bigLevel in [1..10]
        for smallLevel in ["А", "Б", "В", "Г"]
            level = bigLevel + smallLevel
            contests = Contests.findByLevel(level).fetch()
            probNumber = 0
            probAc = 0
            for contest in contests
                for prob in contest.problems
                    ac = Submits.findAcByUserAndProblem(user._id, prob).fetch()
                    foundAc = false
                    for s in ac
                        submitDate = new Date(s.time)
                        if submitDate < lastDate
                            foundAc = true
                    if contest.name[4] != "*"
                        probNumber++
                    if foundAc
                        probAc++
            needProblem = probNumber
            if smallLevel == "В"
                needProblem = probNumber * 0.5
            else if smallLevel == "Г"
                needProblem = probNumber * 0.3333
            if (probAc < needProblem) and ((!user.baseLevel) or (user.baseLevel < level))
                console.log user.name, level
                return level
    return "inf"
    
Meteor.startup ->
    u = Users.findById("87334")
    u.updateLevel()
    console.log u.level, u.startLevel