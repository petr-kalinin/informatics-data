class FullContestChocoCalculator
    constructor: ->
        @fullContests = 0
        
    processContest: (contest) ->
        full = true
        for tmp,p of contest.problems
            if p.accepted <= 0
                full = false
        if full
            @fullContests++
            
    chocos: ->
        if @fullContests == 0
            0
        else if @fullContests == 1
            1
        else
            (@fullContests // 3) + 1
            

class CleanContestChocoCalculator
    constructor: ->
        @cleanContests = 0
        
    processContest: (contest) ->
        clean = true
        for tmp,p of contest.problems
            if (p.attempts > 0) or (p.accepted <= 0)
                clean = false
        if clean
            @cleanContests++
            
    chocos: ->
        @cleanContests

class HalfCleanContestChocoCalculator
    constructor: ->
        @hcleanContests = 0
        
    processContest: (contest) ->
        clean = true
        half = true
        for tmp,p of contest.problems
            if (p.attempts > 0) or (p.accepted <= 0)
                clean = false
            if (p.attempts > 1) or (p.accepted <= 0)
                half = false
        if half and (not clean)
            @hcleanContests++
            
    chocos: ->
        @hcleanContests // 2
        
@FullContestChocoCalculator = FullContestChocoCalculator
@CleanContestChocoCalculator = CleanContestChocoCalculator
@HalfCleanContestChocoCalculator = HalfCleanContestChocoCalculator