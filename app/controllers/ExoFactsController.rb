class ExoFactsController < UIViewController
  include MapKit

  def viewDidLoad
    super

    # check_location
    @add_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @add_button.setTitle("Add", forState:UIControlStateNormal)
    @add_button.sizeToFit
    @add_button.frame = CGRect.new([10, 50], @add_button.frame.size)
    @add_button.addTarget(self, action:"display_lat_long", forControlEvents:UIControlEventTouchUpInside)
    self.view.addSubview(@add_button)

    adler_planetarium = CLLocationCoordinate2D.new(41.866333, -87.606783)
    soldier_field = CLLocationCoordinate2D.new(41.862074, -87.616804)
    ferris_wheel = CLLocationCoordinate2D.new(41.891712, -87.607244)
    mill_park = CLLocationCoordinate2D.new(41.882672, -87.623340)
    merch_mart = CLLocationCoordinate2D.new(41.888477, -87.635407)
    dbc = CLLocationCoordinate2D.new(41.889911, -87.637657)
    us_cell = CLLocationCoordinate2D.new(41.830273, -87.633348)
    wrigley = CLLocationCoordinate2D.new(41.947854, -87.655642)
    pile = CLLocationCoordinate2D.new(41.792015, -87.599959)


    adler_planetarium_region = CLCircularRegion.alloc.initWithCenter(adler_planetarium, radius: 50, identifier:"Adler Planetarium")
    soldier_field_region = CLCircularRegion.alloc.initWithCenter(soldier_field, radius: 50, identifier:"Soldier Field")
    ferris_wheel_region = CLCircularRegion.alloc.initWithCenter(ferris_wheel, radius: 50, identifier:"Navy Pier Ferris Wheel")
    mill_park_region = CLCircularRegion.alloc.initWithCenter(mill_park, radius: 50, identifier:"Millenium Park")
    merch_mart_region = CLCircularRegion.alloc.initWithCenter(merch_mart, radius: 50, identifier:"Merchandise Mart")
    dbc_region = CLCircularRegion.alloc.initWithCenter(dbc, radius: 50, identifier:"Dev Bootcamp")
    us_cell_region = CLCircularRegion.alloc.initWithCenter(us_cell, radius: 50, identifier:"US Cellular Field")
    wrigley_region = CLCircularRegion.alloc.initWithCenter(wrigley, radius: 50, identifier:"Wrigley Field")
    pile_region = CLCircularRegion.alloc.initWithCenter(pile, radius: 50, identifier:"Chicago Pile-1")

    if CLLocationManager.locationServicesEnabled
      @location_manager = CLLocationManager.alloc.init
      @location_manager.desiredAccuracy = 1.0
      @location_manager.distanceFilter = 5
      @location_manager.delegate = self
      @location_manager.pausesLocationUpdatesAutomatically = false
      @location_manager.activityType = CLActivityTypeFitness
      @location_manager.startUpdatingLocation
      puts "We have location enabled!"


      if CLLocationManager.significantLocationChangeMonitoringAvailable
        @location_manager.startMonitoringSignificantLocationChanges
        puts "We're hopefully monitoring changes!'"
      else
        NSLog("Significant location change service not available.")
      end

      if CLLocationManager.regionMonitoringAvailable
        @location_manager.startMonitoringForRegion(adler_planetarium_region, desiredAccuracy: 1.0)
        @location_manager.startMonitoringForRegion(soldier_field_region, desiredAccuracy: 1.0)
        @location_manager.startMonitoringForRegion(ferris_wheel_region, desiredAccuracy: 1.0)
        @location_manager.startMonitoringForRegion(mill_park_region, desiredAccuracy: 1.0)
        @location_manager.startMonitoringForRegion(merch_mart_region, desiredAccuracy: 1.0)
        @location_manager.startMonitoringForRegion(dbc_region, desiredAccuracy: 1.0)
        @location_manager.startMonitoringForRegion(us_cell_region, desiredAccuracy: 1.0)
        @location_manager.startMonitoringForRegion(wrigley_region, desiredAccuracy: 1.0)
        @location_manager.startMonitoringForRegion(pile_region, desiredAccuracy: 1.0)

        @user_coords = @location_manager.location.coordinate
        @regionStateArray = []

        @locations = []
        @location_manager.monitoredRegions.each {|region| @locations << region}

        @regionStateArray << @locations.find do |region|
          calculateDistance(@user_coords, region.center) < 50
        end

        if @regionStateArray.first != nil
          self.view.backgroundColor = UIColor.whiteColor
          @label = UILabel.alloc.initWithFrame(CGRectZero)
          self.title = "Exo System"
          @label.text = 'Exo-system Facts'
          @label.sizeToFit
          @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
          self.view.addSubview(@label)
        elsif @regionStateArray.first == nil
          createMap
        end

        NSLog("Enabling region monitoring.")
      else
        NSLog("Warning: Region monitoring not supported on this device.")
      end

    else
      NSLog("Location services not enabled. FIX IT IN SETTINGS!")
    end

  end


  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemFeatured, tag: 1)
    self
  end

  def calculateDistance(coord1, coord2)
    earths_radius = 6371
    lat_diff = (coord2.latitude - coord1.latitude) * (Math::PI / 180)
    long_diff = (coord2.longitude - coord1.longitude) * (Math::PI / 180)
    lat1_in_radians = coord1.latitude * (Math::PI / 180)
    lat2_in_radians = coord2.latitude * (Math::PI / 180)
    nA = (Math.sin(lat_diff/2) ** 2 ) + Math.cos(lat1_in_radians) * Math.cos(lat2_in_radians) * ( Math.sin(long_diff/2) ** 2 )
    nC = 2 * Math.atan2( Math.sqrt(nA), Math.sqrt( 1 - nA ))
    nD = earths_radius * nC
    return nD * 1000
  end

  def createMap
    map = MapView.new
    map.frame = self.view.frame
    map.delegate = self
    map.region = CoordinateRegion.new([41.8337329, -87.7321555], [1, 1])
    map.shows_user_location = true
    map.zoom_enabled = true
    map.scroll_enabled = true
    view.addSubview(map)
  end

  # def check_location
  #   if (CLLocationManager.locationServicesEnabled)
  #     @location_manager = CLLocationManager.alloc.init
  #     @location_manager.desiredAccuracy = 1.0
  #     @location_manager.distanceFilter = 5
  #     @location_manager.delegate = self
  #     @location_manager.pausesLocationUpdatesAutomatically = false
  #     @location_manager.activityType = CLActivityTypeFitness
  #     @location_manager.startUpdatingLocation
  #   else
  #    show_error_message(' Enable the Location Services for this app in Settings.')
  #   end
  # end

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
    # puts "Getting to did enter region"
    alert = UIAlertView.new
    alert.addButtonWithTitle("OK")
    alert.message = "You have entered the region! Hooray!"
    alert.show

    # notification = UILocalNotification.alloc.init
    # notification.fireDate = NSDate.date
    # notification.timeZone = NSTimeZone.defaultTimeZone
    # notification.alertBody = "Entered Region"

  end

  def locationManager(manager, didExitRegion:region)
    alert = UIAlertView.new
    alert.addButtonWithTitle("OK")
    alert.message = "You left! Come back!"
    alert.show

    # notification = UILocalNotification.alloc.init
    # notification.fireDate = NSDate.date
    # notification.timeZone = NSTimeZone.defaultTimeZone
    # notification.alertBody = "Exited Region"
  end

  def locationManager(manager, monitoringDidFailForRegion:region, withError:error)
    alert = UIAlertView.new
    alert.addButtonWithTitle("OK")
    alert.message = error
    alert.show
  end

  def locationManager(manager, didDetermineState: state, forRegion: region)
    puts "just before iiffffsss"
    @regionStateArray << state
    puts "LOOK HERE!!!! #{@regionStateArray}"

    if state == CLRegionStateInside
      puts "inside state: #{state}"
      puts "Region inside state: #{CLRegionStateInside}"
      puts "Region: #{region.identifier}"
      puts "we're inside YO!"
      general_alert("inside the region! #{region.identifier}")

      # @label = UILabel.alloc.initWithFrame(CGRectZero)
      # self.title = "Exo System"
      # @label.text = 'Exo-system Facts'
      # @label.sizeToFit
      # @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
      # self.view.addSubview(@label)
    # elsif state == CLRegionStateOutside
    else
      puts "outside state: #{state}"
      puts "Region: #{region.identifier}"
      general_alert("outside the region #{region.identifier} :(")
      puts "We're outside YO!"

        # if !@regionStateArray.include?(1)
        #   map = MapView.new
        #   map.frame = self.view.frame
        #   map.delegate = self
        #   map.region = CoordinateRegion.new([41.8337329, -87.7321555], [1, 1])
        #   map.shows_user_location = true
        #   map.zoom_enabled = true
        #   map.scroll_enabled = true
        #   view.addSubview(map)

      # bull = MKPointAnnotation.new
      # bull_coords = CLLocationCoordinate2D.new(41.8896956, -87.634291)
      # bull.coordinate = bull_coords
      # bull.title = "Bull and Bear"
      # map.addAnnotation(bull)
        # end
    # else
    #   general_alert("HEY HEYE HEHEYYEHHEYEYHEY HEY hi")
    #   puts "another erroooorr?"
    end

    puts "wtf is happening at the END - THIS IS THE LAST LINE"
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
