class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    application.setStatusBarStyle(UIStatusBarStyleLightContent)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible


    if Twitter::Composer.available?
      Twitter.sign_in do |granted, ns_error|
        if granted
          puts "Twitter ID #{Twitter.accounts[0].user_id}"
          @defaults = NSUserDefaults.standardUserDefaults
          @defaults["twitter_id"] = Twitter.accounts[0].user_id
          
          exo_facts_controller = ExoFactsController.alloc.initWithNibName(nil, bundle: nil)
          geo_cache_controller = GeoCachingController.alloc.initWithNibName(nil, bundle: nil)
          @visited_sites_controller = VisitedSitesController.alloc.initWithNibName(nil, bundle: nil)
          @visited_nav_controller = UINavigationController.alloc.initWithRootViewController(@visited_sites_controller)
          adler_controller = AdlerInfoController.alloc.initWithNibName(nil, bundle: nil)

          tab_controller = UITabBarController.alloc.initWithNibName(nil, bundle: nil)
          tab_controller.viewControllers = [exo_facts_controller, geo_cache_controller, @visited_nav_controller, adler_controller]

          @window.rootViewController = tab_controller
        else
          label = UILabel.alloc.initWithFrame(CGRectZero)
          # @window.backgroundColor = UIColor.whiteColor
          label.text = "Please allow access to Twitter in settings"
          label.sizeToFit
          label.styleClass = 'message'
          label.center = CGPointMake(@window.frame.size.width / 2, @window.frame.size.height / 2)
          @window.addSubview(label)
        end
      end
    else
      label = UILabel.alloc.initWithFrame(CGRectZero)
      # @window.backgroundColor = UIColor.whiteColor
      label.text = "Login to Twitter in your settings!"
      label.sizeToFit
      label.styleClass = 'message'
      label.center = CGPointMake(@window.frame.size.width / 2, @window.frame.size.height / 2)
      @window.addSubview(label)
    end
    true
  end
end
