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

        
Template.oneWeekSolved.helpers
    weekSolved: ->
        num = @user.solvedByWeek[@weekNumber]
        if num then num else ""
        
    bgColor: ->
        num = @user.solvedByWeek[@weekNumber]
        if !num
            "#ffffff"
        else if num<=2
            "#ff8866"
        else if num<=5
            "#ffff00"
        else if num<=8
            "#44aa55"
        else 
            "#22ff22"
            
