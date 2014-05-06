class SystemsController < UIViewController
  attr_accessor :location_id
  def viewDidLoad
    super
    
    view.styleId = 'SystemsView'
    id = self.location_id

    System.pull_system_data(id) do |system|
      self.title = system[:name]

      frame = UIScreen.mainScreen.applicationFrame
      origin = frame.origin
      size = frame.size
      body = UITextView.alloc.initWithFrame([[origin.x, origin.y + 20], [size.width, size.height]])
      body.text = system[:description]
      body.editable = false
      body.styleClass = 'PlanetText'
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
    self.location_id = params[:location_id]
    self
  end
end
