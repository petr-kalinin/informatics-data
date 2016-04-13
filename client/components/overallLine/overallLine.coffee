Template.overallLine.helpers
    contests: ->
        Contests.findByLevel("" + this)
        
    tables: ->
        Tables.findAll()

Template.overallResult.helpers
    result: ->
        res = Results.findByUserAndTable(@user._id, @table._id).fetch()[0]
        if not res
            return ""
        s = 0
        ok = 0
        total = 0
        for c in Contests.findByLevel(@level).fetch()
            s = s + res.contests[c._id].solved 
            ok = ok + res.contests[c._id].ok
            total = total + c.problems.length
        s + (if ok > 0 then "+" + ok else "") + " / " + total

    bgColor: ->
        res = Results.findByUserAndTable(@user._id, @table._id).fetch()[0]
        if not res
            return "#ffffff"
        s = 0
        ok = 0
        total = 0
        for c in Contests.findByLevel(@level).fetch()
            s = s + res.contests[c._id].solved 
            ok = ok + res.contests[c._id].ok
            total = total + c.problems.length
        if s == total
            return "#00ff00"
        if @level[@level.length-1] == "В" and s*2 >= total
            return "#00bb00"
        if @level[@level.length-1] == "Г" and s*3 >= total
            return "#00bb00"
        if s > 0
            return "#dddddd"
        return "#ffffff"

        
