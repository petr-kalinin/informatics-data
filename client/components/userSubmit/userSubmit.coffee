Template.userSubmit.helpers
    text: ->
        @result.contests[@contest._id].problems[@problem._id].text

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
        else if data.attempts > 0
            "wa"
        else
            undefined
            
    active: ->
        if Session.get("activeUser") == @result.user
            "active"
        else
            ""

            
Template.userSubmit.events
    'dblclick .res': (e,t) ->
        runId = t.data.result.contests[@contest._id].problems[@problem._id].submitId
        runSuff = ''
        if runId
            runSuff = '&run_id=' + runId
        url = 'http://informatics.mccme.ru/moodle/mod/statements/view3.php?chapterid=' + t.data.problem._id + runSuff
        window.open(url, '_blank')
