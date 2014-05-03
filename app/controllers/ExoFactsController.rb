class ExoFactsController < UIViewController
  def viewDidLoad
    super


    self.view.backgroundColor = UIColor.whiteColor
    @label = UILabel.alloc.initWithFrame(CGRectZero)
    self.title = "Exo System"
    @label.text = 'Exo-system Facts'
    @label.sizeToFit
    @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
    self.view.addSubview(@label)

    check_location
    @add_button = UIButton.buttonWithType(UIButtonTypeRoundedRect) 
    @add_button.setTitle("Add", forState:UIControlStateNormal) 
    @add_button.sizeToFit
    @add_button.frame = CGRect.new([10, 50], @add_button.frame.size)
    @add_button.addTarget(self, action:"display_lat_long", forControlEvents:UIControlEventTouchUpInside)
    self.view.addSubview(@add_button)
  end

  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemFeatured, tag: 1)
    self
  end

  def check_location 
   if (CLLocationManager.locationServicesEnabled) 
     @location_manager = CLLocationManager.alloc.init 
     @location_manager.desiredAccuracy = KCLLocationAccuracyKilometer 
     @location_manager.delegate = self 
     @location_manager.startUpdatingLocation 
   else 
     show_error_message(' Enable the Location Services for this app in Settings.') 
   end 
  end

  def locationManager(manager, didUpdateToLocation:newLocation, fromLocation:oldLocation) 
   @latitude = newLocation.coordinate.latitude 
   @longitude = newLocation.coordinate.longitude 
   @location_manager.stopUpdatingLocation    
  end 
 
  def locationManager(manager, didFailWithError:error) 
    show_error_message('Enable the Location Services for this app in Settings.') 
  end 

  def show_error_message(message) 
    alert = UIAlertView.new 
    alert.addButtonWithTitle("OK") 
    alert.message = message 
    alert.show 
  end 

  def display_lat_long
    alert = UIAlertView.new 
    alert.addButtonWithTitle("OK") 
    alert.message = "Lat: #{@latitude}, Long: #{@longitude}"
    alert.show 
  end

end
