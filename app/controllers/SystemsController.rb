class SystemsController < UIViewController
  attr_accessor :location_id
  def viewDidLoad
    super
    
    view.styleId = 'SystemsView'
    id = self.location_id

    @defaults = NSUserDefaults.standardUserDefaults

    System.pull_system_data(id) do |system|
      self.title = system[:name]

      frame = UIScreen.mainScreen.applicationFrame
      origin = frame.origin
      size = frame.size
      body = UITextView.alloc.initWithFrame([[origin.x, origin.y + 20], [size.width, size.height]])
      body.backgroundColor = UIColor.blackColor
      body.text = system[:description]
      body.editable = false
      body.styleClass = 'PlanetText'
      scroll_view = UIScrollView.alloc.initWithFrame(frame)

      scroll_view.showsVerticalScrollIndicator = true
      scroll_view.scrollEnabled = true
      scroll_view.addSubview(body)
      scroll_view.contentSize = body.frame.size
      self.view.addSubview(scroll_view)

      @achievement_label = UILabel.alloc.initWithFrame(CGRectZero)
      @achievement_label.styleClass = 'h2'
      @achievement_label.text = "Unlocked this page by visiting"
      @achievement_label.sizeToFit
      @achievement_label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 110)
      @achievement_label.styleClass = 'visit_achievement'
      self.view.addSubview(@achievement_label)

      @achievement_location = UILabel.alloc.initWithFrame(CGRectZero)
      @achievement_location.styleClass = 'h2'
      @achievement_location.text = "#{get_location_name(system[:location_id])}"
      @achievement_location.sizeToFit
      @achievement_location.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 90)
      @achievement_location.styleClass = 'visit_achievement'
      self.view.addSubview(@achievement_location)      
    end
  end

  def initWithParams(params = {})
    init()
    self.location_id = params[:location_id]
    self
  end

  def get_location_name(system_location_id)
    all_regions = Location.all_regions

    all_regions.each_with_index do |region, index|
      location_id = index + 1
      if location_id == system_location_id
        return region.identifier
      end
    end
  end
end
