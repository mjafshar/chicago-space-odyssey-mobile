class AdlerInfoController < UIViewController
  def viewDidLoad
    super
    frame = UIScreen.mainScreen.applicationFrame
    origin = frame.origin
    size = frame.size

    view.styleId = 'AdlerView'

    @adler_title = UILabel.alloc.initWithFrame(CGRectZero)
    @adler_title.styleClass = 'h1'
    @adler_title.text = "Adler Planetarium"
    @adler_title.sizeToFit
    @adler_title.center = CGPointMake(self.view.frame.size.width / 2, 90)
    self.view.addSubview(@adler_title)

    action_call = UITextView.alloc.initWithFrame([[origin.x, origin.y + 370], [size.width, size.height]])
    action_call.backgroundColor = UIColor.clearColor
    action_call.text = "Visit the Adler Planetarium website."
    action_call.editable = false
    action_call.styleId = 'ActionCallLabel'
    self.view.addSubview(action_call)

    adler_link = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    adler_link.setTitle("www.adlerplanetarium.org", forState: UIControlStateNormal)
    adler_link.setFont(UIFont.fontWithName('Avenir Next', size:16))
    adler_link.center = CGPointMake(20, size.height - 120)

    adler_link.when(UIControlEventTouchUpInside) do
      App.open_url('http://www.adlerplanetarium.org')
    end

    @body = UITextView.alloc.initWithFrame([[origin.x, origin.y + 100], [size.width, size.height]])
    @body.backgroundColor = UIColor.clearColor
    @body.text = "The Adler Planetarium was founded in 1930 by Chicago business leader, Max Adler. Located on Northerly Island in Chicago, Illinois the Adler is America's first planetarium and part of Chicago's Museum Campus, which includes the John G. Shedd Aquarium and The Field Museum. The Adler's mission is to inspire exploration and understanding of the Universe."
    @body.editable = false
    @body.styleId = 'AdlerBody'
    self.view.addSubview(@body)
    self.view.addSubview(adler_link)
  end

  def initWithNibName(name, bundle: bundle)
    super
    @adler = UIImage.imageNamed('tele.png')
    @adlerSel = UIImage.imageNamed('tele-select.png')
    self.tabBarItem = UITabBarItem.alloc.initWithTitle('Adler', image: @adler, tag: 4)
    self.tabBarItem.setFinishedSelectedImage(@adlerSel, withFinishedUnselectedImage:@adler)
    self
  end
end
