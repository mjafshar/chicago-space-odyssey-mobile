class AdlerInfoController < UIViewController
  def viewDidLoad
    super
    view.styleId = 'AdlerView'
    # self.view.backgroundColor = UIColor.whiteColor
    @label = UILabel.alloc.initWithFrame(CGRectZero)
    self.title = "Adler"
    @label.text = 'Visit the Adler'
    @label.sizeToFit
    @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
    @label.styleClass = 'message'
    self.view.addSubview(@label)
  end

  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemMore, tag: 4)
    self
  end
end
