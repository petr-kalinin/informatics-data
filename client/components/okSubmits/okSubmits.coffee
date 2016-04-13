Template.okSubmits.helpers
    submits: ->
        Submits.findByOutcome("OK")
        
    user: ->
        Users.findById(@user).name
        
    needSubmit: ->
        for c in Contests.findAll().fetch()
            for p in c.problems
                if p._id == @problem
                    return true
        return false
    
    problem: ->
        for c in Contests.findAll().fetch()
            for p in c.problems
                if p._id == @problem
                    return c.name + ": " + p.name
                
    href: ->
        url = 'http://informatics.mccme.ru/moodle/mod/statements/view3.php?chapterid='+@problem+'&submit&user_id=' + @user
        return url