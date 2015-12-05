Template.userSubmit.helpers
    outcome: ->
        @row.outcomes[@problem._id].text

    title: ->
        user = Users.findById(@row.user)
        user.name + ": " + @problem.name
        
    class: ->
        data = @row.outcomes[@problem._id]
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
            
Template.userSubmit.events
    'dblclick .res': (e,t) ->
        url = 'http://informatics.mccme.ru/moodle/mod/statements/view3.php?chapterid=' + t.data.problem._id + '&run_id=' + t.data.row.outcomes[t.data.problem._id].submitId
        window.open(url, '_blank')
