@calculateLevel = (user) ->
    for bigLevel in [1..10]
        for smallLevel in ["А", "Б", "В", "Г"]
            level = bigLevel + smallLevel
            contests = Contests.findByLevel(level).fetch()
            probNumber = 0
            probAc = 0
            for contest in contests
                for prob in contest.problems
                    ac = Submits.findAcByUserAndProblem(user._id, prob).count()
                    if contest.name[4] != "*"
                        probNumber++
                    if ac
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
    Users.findById("87334").updateLevel()