class ExoFactsController < UIViewController
  include MapKit

  def viewDidLoad
    super
    @defaults = NSUserDefaults.standardUserDefaults
    @defaults["user_location"] = nil
    # check_location
    @add_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @add_button.setTitle("Add", forState:UIControlStateNormal)
    @add_button.sizeToFit
    @add_button.frame = CGRect.new([10, 50], @add_button.frame.size)
    @add_button.addTarget(self, action:"display_lat_long", forControlEvents:UIControlEventTouchUpInside)
    # self.view.addSubview(@add_button)

    @adler_planetarium = CLLocationCoordinate2D.new(41.866333, -87.606783)
    @soldier_field = CLLocationCoordinate2D.new(41.862074, -87.616804)
    @ferris_wheel = CLLocationCoordinate2D.new(41.891712, -87.607244)
    @mill_park = CLLocationCoordinate2D.new(41.882672, -87.623340)
    @merch_mart = CLLocationCoordinate2D.new(41.888477, -87.635407)
    @dbc = CLLocationCoordinate2D.new(41.889911, -87.637657)
    @us_cell = CLLocationCoordinate2D.new(41.830273, -87.633348)
    @wrigley = CLLocationCoordinate2D.new(41.947854, -87.655642)
    @pile = CLLocationCoordinate2D.new(41.792015, -87.599959)

    @adler_planetarium_region = CLCircularRegion.alloc.initWithCenter(@adler_planetarium, radius: 100, identifier:"Adler Planetarium")
    @soldier_field_region = CLCircularRegion.alloc.initWithCenter(@soldier_field, radius: 100, identifier:"Soldier Field")
    @ferris_wheel_region = CLCircularRegion.alloc.initWithCenter(@ferris_wheel, radius: 100, identifier:"Navy Pier Ferris Wheel")
    @mill_park_region = CLCircularRegion.alloc.initWithCenter(@mill_park, radius: 100, identifier:"Millenium Park")
    @merch_mart_region = CLCircularRegion.alloc.initWithCenter(@merch_mart, radius: 100, identifier:"Merchandise Mart")
    @dbc_region = CLCircularRegion.alloc.initWithCenter(@dbc, radius: 100, identifier:"Dev Bootcamp")
    @us_cell_region = CLCircularRegion.alloc.initWithCenter(@us_cell, radius: 100, identifier:"US Cellular Field")
    @wrigley_region = CLCircularRegion.alloc.initWithCenter(@wrigley, radius: 100, identifier:"Wrigley Field")
    @pile_region = CLCircularRegion.alloc.initWithCenter(@pile, radius: 100, identifier:"Chicago Pile-1")

    @all_regions = [@adler_planetarium_region, @soldier_field_region, @ferris_wheel_region, @mill_park_region, @merch_mart_region, @dbc_region, @us_cell_region, @wrigley_region, @pile_region]

    if CLLocationManager.locationServicesEnabled

      if (CLLocationManager.authorizationStatus == KCLAuthorizationStatusAuthorized)
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
          @location_manager.startMonitoringForRegion(@adler_planetarium_region, desiredAccuracy: 1.0)
          @location_manager.startMonitoringForRegion(@soldier_field_region, desiredAccuracy: 1.0)
          @location_manager.startMonitoringForRegion(@ferris_wheel_region, desiredAccuracy: 1.0)
          @location_manager.startMonitoringForRegion(@mill_park_region, desiredAccuracy: 1.0)
          @location_manager.startMonitoringForRegion(@merch_mart_region, desiredAccuracy: 1.0)
          @location_manager.startMonitoringForRegion(@dbc_region, desiredAccuracy: 1.0)
          @location_manager.startMonitoringForRegion(@us_cell_region, desiredAccuracy: 1.0)
          @location_manager.startMonitoringForRegion(@wrigley_region, desiredAccuracy: 1.0)
          @location_manager.startMonitoringForRegion(@pile_region, desiredAccuracy: 1.0)


          NSLog("The location manager: #{@location_manager.inspect}")
          @user_coords = @location_manager.location.coordinate
          @regionStateArray = []

          @locations = []
          @location_manager.monitoredRegions.each {|region| @locations << region}

          @regionStateArray << @locations.find do |region|
            calculateDistance(@user_coords, region.center) < 100
          end

          if @regionStateArray.first != nil
            @all_regions.each_with_index do |location, index|
              puts location.identifier
              if location.containsCoordinate(@user_coords)
                puts "Contains: #{location.identifier}, #{index}"
                # general_alert("#{location.identifier} contains your coords")
                location_id = index + 1

                # @defaults = NSUserDefaults.standardUserDefaults
                @defaults["user_location"] = location_id

                self.view.backgroundColor = UIColor.whiteColor
                # systems_controller = SystemsController.alloc.initWithParams({location_id: location_id})
                System.pull_system_data(location_id) do |system|
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
            end
            # self.view.backgroundColor = UIColor.whiteColor
            # @label = UILabel.alloc.initWithFrame(CGRectZero)
            # self.title = "Exo System"
            # @label.text = 'Exo-system Facts'
            # @label.sizeToFit
            # @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
            # systems_controller = SystemsController.alloc.initWithParams({location_id: location_id})
            # self.view.addSubview(systems_controller)
          elsif @regionStateArray.first == nil
            createMap(@all_regions)
          end

          NSLog("Enabling region monitoring.")
        else
          NSLog("Warning: Region monitoring not supported on this device.")
        end
      else
        @location_manager = CLLocationManager.alloc.init
        @location_manager.startUpdatingLocation
        NSLog("Location services for this app not enabled")
        self.view.backgroundColor = UIColor.whiteColor
        general_alert("Location services not enabled.")
      end
    else
      self.view.backgroundColor = UIColor.whiteColor
      general_alert("Location services not enabled.")
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

  def createMap(all_regions)
    map = MapView.new
    map.frame = self.view.frame
    map.delegate = self
    map.region = CoordinateRegion.new([41.8337329, -87.7321555], [1, 1])
    map.shows_user_location = true
    map.zoom_enabled = true
    map.scroll_enabled = true

    all_regions.each do |region|
      place = MKPointAnnotation.new
      place.coordinate = region.center
      place.title = region.identifier
      map.addAnnotation(place)
    end

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
    NSLog("The locations coming through: #{locations.inspect}")
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
    # alert = UIAlertView.new
    # alert.addButtonWithTitle("OK")
    # alert.message = "You have entered the region! Hooray!"
    # alert.show

  end

  def locationManager(manager, didExitRegion:region)
    # alert = UIAlertView.new
    # alert.addButtonWithTitle("OK")
    # alert.message = "You left! Come back!"
    # alert.show
    @defaults["user_location"] = nil
  end

  def locationManager(manager, monitoringDidFailForRegion:region, withError:error)
    alert = UIAlertView.new
    alert.addButtonWithTitle("OK")
    alert.message = error
    alert.show
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

