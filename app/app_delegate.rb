class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible

    exo_facts_controller = ExoFactsController.alloc.initWithNibName(nil, bundle: nil)
    geo_cache_controller = GeoCachingController.alloc.initWithNibName(nil, bundle: nil)
    visited_sites_controller = VisitedSitesController.alloc.initWithNibName(nil, bundle: nil)
    adler_controller = AdlerInfoController.alloc.initWithNibName(nil, bundle: nil)

    tab_controller = UITabBarController.alloc.initWithNibName(nil, bundle: nil)
    tab_controller.viewControllers = [exo_facts_controller, geo_cache_controller, visited_sites_controller, adler_controller]

    @window.rootViewController = tab_controller

    true
  end
end
