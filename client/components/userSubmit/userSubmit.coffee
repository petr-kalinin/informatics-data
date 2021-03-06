Template.userSubmit.helpers
    text: ->
        data = @result.contests[@contest._id].problems[@problem._id]
        if data.accepted == Submits.DQconst
            ""
        else 
            data.text

    title: ->
        user = Users.findById(@result.user)
        user.name + ": " + @problem.name
        
    class: ->
        data = @result.contests[@contest._id].problems[@problem._id]
        if data.accepted == 1
            "ac"
        else if data.accepted == -1
            "ig"
        else if data.success == 1
            "ok"
        else if data.accepted == Submits.DQconst
            "dq"
        else if data.attempts > 0
            "wa"
        else
            undefined
            
    active: ->
        if Session.get("activeUser") == @result.user
            "active"
        else
            ""

    inactive: ->
        if (Session.get("activeUser") and (Session.get("activeUser") != @result.user))
            "inactive"
        else
            ""
            
Template.userSubmit.events
    'dblclick .res': (e,t) ->
        runId = t.data.result.contests[t.data.contest._id].problems[t.data.problem._id].submitId
        runSuff = ''
        if runId
            runSuff = '&run_id=' + runId
        if e.ctrlKey
            url = 'http://informatics.mccme.ru/moodle/mod/statements/view3.php?chapterid='+@problem._id+'&submit&user_id=' + @result.user
        else
            url = 'http://informatics.mccme.ru/moodle/mod/statements/view3.php?chapterid=' + t.data.problem._id + runSuff
        window.open(url, '_blank')
