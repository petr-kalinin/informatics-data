Template.userSubmit.helpers
    outcome: ->
        console.log this.problem.letter
        res = Results.display(this.user._id, this.problem)
        res.text
        
    class: ->
        res = Results.display(this.user._id, this.problem)
        if res.accepted == 1
            "ac"
        else if res.accepted == -1
            "ig"
        else if res.success == 1
            "ok"
        else if res.attempts > 0
            "wa"
        else
            undefined
            
