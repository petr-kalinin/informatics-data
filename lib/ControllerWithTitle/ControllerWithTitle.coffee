class @ControllerWithTitle extends RouteController
    title: ->
        ""

    onAfterAction: ->
        thisTitle = @title()
        if !thisTitle
            thisTitle = "Сводные таблицы"
#        SEO.set title: thisTitle

    fastRender: true
