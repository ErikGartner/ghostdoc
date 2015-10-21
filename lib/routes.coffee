Router.route('/', ->
  GAnalytics.pageview()
  @render('home')
)
