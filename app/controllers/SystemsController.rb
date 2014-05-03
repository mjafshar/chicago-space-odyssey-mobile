class SystemsController < UIViewController
  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.whiteColor
    @label = UILabel.alloc.initWithFrame(CGRectZero)
    system = System.pull_system_data(1) do |system|
      if system.nil?
        self.title = "Error"
        @label.text = "Error"
      else
        puts "=================="
        p system
        puts "=================="
        self.title = system[:name]
        @label.text = system[:description]
      end
    end
    # self.title = "Systems"
    @label.text = "Awesome System"
    @label.sizeToFit
    @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
    self.view.addSubview(@label)
  end

  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemDownloads, tag: 2)
    self
  end
end
