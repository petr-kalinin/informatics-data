Template.userSubmit.helpers
    outcome: ->
        @row.outcomes[@problem._id].text
        
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
            
