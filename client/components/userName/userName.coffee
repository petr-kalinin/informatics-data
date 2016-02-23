MAX_ACTIVITY = 20
MAX_RATING = 100000

Template.userName.helpers
    color: ->
        activity = Math.min(@activity + 1, MAX_ACTIVITY)
        rating = Math.min(@rating + 1, MAX_RATING) 
        h = 5/6 * (1 - Math.log(rating) / Math.log(MAX_RATING))
        v = Math.log(activity) / Math.log(MAX_ACTIVITY)
        return "#" + tinycolor.fromRatio({h: h, s: 1, v: v}).toHex()
