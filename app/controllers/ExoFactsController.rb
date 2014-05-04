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

    dbc = CLLocationCoordinate2D.new(41.8917097, -87.6109747)
    NSLog("=================================================")
    dbc_region = CLCircularRegion.alloc.initWithCenter(dbc, radius:20, identifier:"Bubba Gump")
    NSLog("The dbc_region: #{dbc_region.identifier}")
    @location_manager.startMonitoringForRegion(dbc_region)
    @location_manager.requestStateForRegion(dbc_region)
  end


  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemFeatured, tag: 1)
    self
  end

  def check_location 
   if (CLLocationManager.locationServicesEnabled) 
     @location_manager = CLLocationManager.alloc.init 
     @location_manager.desiredAccuracy = KCLLocationAccuracyBest
     @location_manager.distanceFilter = 5
     @location_manager.delegate = self 
     @location_manager.pausesLocationUpdatesAutomatically = false
     @location_manager.startUpdatingLocation 
   else 
     show_error_message(' Enable the Location Services for this app in Settings.') 
   end 
  end

  def locationManager(manager, didUpdateLocations:locations) 
   @latitude = locations.last.coordinate.latitude 
   @longitude = locations.last.coordinate.longitude 
   # @location_manager.stopUpdatingLocation    
   # @location_manager.startUpdatingLocation 
  end 
 
  def locationManager(manager, didFailWithError:error) 
    show_error_message('Enable the Location Services for this app in Settings.') 
  end 

  def locationManager(manager, didEnterRegion:region)
    puts "Getting to did enter region"
    alert = UIAlertView.new 
    alert.addButtonWithTitle("OK") 
    alert.message = "You have entered the region! Hooray!" 
    alert.show     
  end

  def locationManager(manager, didExitRegion:region)
    general_alert("exited region")
  end

  def locationManager(manager, monitoringDidFailForRegion:region, withError:error)
    alert = UIAlertView.new 
    alert.addButtonWithTitle("OK") 
    alert.message = error 
    alert.show     
  end

  def locationManager(manager, didDetermineState: state, forRegion: region)
    if state == CLRegionStateInside
      general_alert("inside the region!")
    else
      general_alert("outside the region :(")
    end
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

  def general_alert(message)
    alert = UIAlertView.new 
    alert.addButtonWithTitle("OK") 
    alert.message = "#{message}"
    alert.show  
  end

end
