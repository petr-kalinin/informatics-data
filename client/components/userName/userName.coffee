MAX_ACTIVITY = 7
MAX_RATING = 10 * (Math.pow(LEVEL_RATING_EXP, 11) - 1) / (LEVEL_RATING_EXP - 1)

Template.userName.helpers
    color: ->
        activity = Math.min(@activity + 1, MAX_ACTIVITY + 1)
        rating = Math.min(@rating + 1, MAX_RATING + 1) 
        h = 11/12 * (1 - Math.log(rating) / Math.log(MAX_RATING + 1))
        v = 0.3 + 0.7 * Math.log(activity) / Math.log(MAX_ACTIVITY + 1)
        if @activity < ACTIVITY_THRESHOLD
            v = 0
        return "#" + tinycolor.fromRatio({h: h, s: 1, v: v}).toHex()
