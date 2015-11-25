Template.userSubmit.helpers
    outcome: ->
        res = Submits.displayProblemResult(this.user._id, this.problem)
        res.text
        
    class: ->
        res = Submits.displayProblemResult(this.user._id, this.problem)
        console.log res
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
            
