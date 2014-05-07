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
    @adler = UIImage.imageNamed('tele.png')
    @adlerSel = UIImage.imageNamed('tele-select.png')
    self.tabBarItem = UITabBarItem.alloc.initWithTitle('Adler', image: @adler, tag: 4)
    self.tabBarItem.setFinishedSelectedImage(@adlerSel, withFinishedUnselectedImage:@adler)
    # self.tabBarItem.title.styleClass = 'tab-text'
    self
  end
end
