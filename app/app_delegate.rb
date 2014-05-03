class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @ra = ReverseAuth.new
    @ra.getData
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible

    if Twitter::Composer.available? 
      exo_facts_controller = ExoFactsController.alloc.initWithNibName(nil, bundle: nil)
      geo_cache_controller = GeoCachingController.alloc.initWithNibName(nil, bundle: nil)
      visited_sites_controller = VisitedSitesController.alloc.initWithNibName(nil, bundle: nil)
      adler_controller = AdlerInfoController.alloc.initWithNibName(nil, bundle: nil)

      tab_controller = UITabBarController.alloc.initWithNibName(nil, bundle: nil)
      tab_controller.viewControllers = [exo_facts_controller, geo_cache_controller, visited_sites_controller, adler_controller]

      @window.rootViewController = tab_controller
    else
      label = UILabel.alloc.initWithFrame(CGRectZero)
      @window.backgroundColor = UIColor.whiteColor
      label.text = "Login to Twitter!"
      label.sizeToFit
      label.center = CGPointMake(@window.frame.size.width / 2, @window.frame.size.height / 2)
      @window.addSubview(label)
    end  

    # Twitter.sign_in do |granted, error|
    #   # p Twitter.accounts.first.user_id
    #   if granted
    #     exo_facts_controller = ExoFactsController.alloc.initWithNibName(nil, bundle: nil)
    #     geo_cache_controller = GeoCachingController.alloc.initWithNibName(nil, bundle: nil)
    #     visited_sites_controller = VisitedSitesController.alloc.initWithNibName(nil, bundle: nil)
    #     adler_controller = AdlerInfoController.alloc.initWithNibName(nil, bundle: nil)

    #     tab_controller = UITabBarController.alloc.initWithNibName(nil, bundle: nil)
    #     tab_controller.viewControllers = [exo_facts_controller, geo_cache_controller, visited_sites_controller, adler_controller]

    #     @window.rootViewController = tab_controller
    #     p "we got here instead"
    #     p Twitter.accounts[0]
    #     # compose = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    #     # compose.setTitle("Compose", forState:UIControlStateNormal)
    #     # compose.sizeToFit
    #     # puts "Error?"
    #     # tab_controller.view.addSubview(compose)
    #     # compose.when UIControlEventTouchUpInside do
    #     #   account = Twitter.accounts[0]
    #     #   account.compose(tweet: "Hello World!", urls: ["http://clayallsopp.com"]) do |composer|
    #     #     p "Done? #{composer.done?}"
    #     #     p "Cancelled? #{composer.cancelled?}"
    #     #     p "Error #{composer.error.inspect}"
    #     #   end
    #     # end

    #     # timeline = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    #     # timeline.setTitle("Timeline", forState:UIControlStateNormal)
    #     # timeline.setTitle("Loading", forState:UIControlStateDisabled)
    #     # timeline.sizeToFit
    #     # timeline.frame = compose.frame.below(10)
    #     # tab_controller.view.addSubview(timeline)
    #     # timeline.when UIControlEventTouchUpInside do
    #     #   timeline.enabled = false
    #     #   account = Twitter.accounts[0]
    #     #   account.get_timeline do |hash, error|
    #     #     timeline.enabled = true
    #     #     p "Timeline #{hash}"
    #     #   end
    #     # end
    #   else
    #     p "wtf"
    #     label = UILabel.alloc.initWithFrame(CGRectZero)
    #     label.text = "Denied :("
    #     label.sizeToFit
    #     label.center = self.view.frame.center
    #     # @window.rootViewController = LoginController.alloc.initWithNibName(nil, bundle: nil)
    #     # self.view.addSubview(label)
    #   end
    # end
    true
  end
end

class ReverseAuth

  def getData
    url = NSURL.URLWithString "https://api.twitter.com/oauth/request_token"
    dict = {x_auth_mode: "reverse_auth"}
    @step1Request = TWSignedRequest.alloc.initWithURL(url, parameters: dict, requestMethod: TWSignedRequestMethodPOST)
    @step1Request.consumerKey = 'CONSUMER_KEY'
    @step1Request.consumerSecret = 'CONSUMER_SECRET'
    Dispatch::Queue.concurrent.async do
      @step1Request.performRequestWithHandler(->(data, resp, err){
        Dispatch::Queue.main.async do
          setData(data)
        end
      })
    end
  end

  def setData(data)
    puts "This is the return data: #{data.inspect}"
  end

end

class Twitter::User
  def user_id
    self.ac_account.valueForKeyPath("properties")["user_id"]
  end
end
