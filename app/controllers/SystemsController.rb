class SystemsController < UIViewController
  attr_accessor :system_id
  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.whiteColor
    id = self.system_id

    System.pull_system_data(id) do |system|
      self.title = system[:name]

      frame = UIScreen.mainScreen.applicationFrame
      origin = frame.origin
      size = frame.size
      body = UITextView.alloc.initWithFrame([[origin.x, origin.y + 20], [size.width, size.height]])
      body.text = system[:description]
      body.editable = false
      scroll_view = UIScrollView.alloc.initWithFrame(frame)

      scroll_view.showsVerticalScrollIndicator = true
      scroll_view.scrollEnabled = true
      scroll_view.addSubview(body)
      scroll_view.contentSize = body.frame.size
      self.view.addSubview(scroll_view)
    end
  end

  def initWithParams(params = {})
    init()
    self.system_id = params[:system_id]
    self
  end
end
