Template.userSubmit.helpers
    outcome: ->
        submits = Submits.findByUserAndProblem(this.user.id, this.problem)
        res = ""
        submits.forEach (submit) ->
            res = res + submit.outcome
        res ||  "-"
            
