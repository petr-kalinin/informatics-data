Template.solvedByWeekLine.helpers
    weekSet: ->
        thisStart = new Date(startDayForWeeks["" + @userList])
        now = new Date()
        nowWeek = Math.floor((now - thisStart) / MSEC_IN_WEEK)
        [0..nowWeek]
        
    activity: ->
        a = Math.floor(@user.activity / ACTIVITY_THRESHOLD) * ACTIVITY_THRESHOLD
        s = a.toFixed(5)
        s.replace(/\.?0+$/gm,"")

    admin: ->
        isAdmin()
        
Template.solvedByWeekLine.events
    "submit .baseLevel": (event) ->
        Meteor.call("setBaseLevel", @user._id, event.target.newLevel.value)
        event.preventDefault()
        false
        
Template.oneWeekSolved.helpers
    weekSolved: ->
        num = @user.solvedByWeek[@weekNumber]
        res = if num then num else ""
        if @user.okByWeek
            ok = @user.okByWeek[@weekNumber]
            if ok
                res = if res then res + "+" + ok else "0+" + ok
        res
        
    bgColor: ->
        num = @user.solvedByWeek[@weekNumber]
        if !num
            "#ffffff"
        else if num<=2
            "#ddffdd"
        else if num<=5
            "#bbffbb"
        else if num<=8
            "#88ff88"
        else 
            "#22ff22"
            
