class SystemsController < UIViewController
  attr_accessor :system_id
  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.whiteColor
    @label = UILabel.alloc.initWithFrame(CGRectZero)
    id = self.system_id
    System.pull_system_data(id) do |system|
      if system.nil?
        self.title = "Error"
        @label.text = "Error"
      else
        self.title = system[:name]
        @label.text = system[:description]
        @label.sizeToFit
        @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
        self.view.addSubview(@label)
      end
    end
  end

  def initWithParams(params = {})
    init()
    self.system_id = params[:system_id]
    self
  end
end
