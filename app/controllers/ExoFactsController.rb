class ExoFactsController < UIViewController
  include MapKit

  def viewDidLoad
    super
    view.styleId = 'ExoView'
    self.title = "Discover"
    
    @defaults = NSUserDefaults.standardUserDefaults
    @defaults["user_location"] = nil

    @all_regions = Location.all_regions

    if CLLocationManager.locationServicesEnabled

      if (CLLocationManager.authorizationStatus == KCLAuthorizationStatusAuthorized)
        @location_manager = set_location_manager

        if CLLocationManager.significantLocationChangeMonitoringAvailable
          @location_manager.startMonitoringSignificantLocationChanges
        else
          NSLog("Significant location change service not available.")
        end

        if CLLocationManager.regionMonitoringAvailable
          @all_regions.each do |region|
            @location_manager.startMonitoringForRegion(region, desiredAccuracy: 1.0)
          end

          @user_coords = @location_manager.location.coordinate
          @regionStateArray = []

          @locations = []
          @location_manager.monitoredRegions.each {|region| @locations << region}

          @regionStateArray << @locations.find do |region|
            calculateDistance(@user_coords, region.center) < 100
          end

          if @regionStateArray.first != nil
            
            @all_regions.each_with_index do |location, index|
              if location.containsCoordinate(@user_coords)
                location_id = index + 1

                @defaults["user_location"] = location_id
              
                populate_view_with_data(location_id)
              end
            end

          elsif @regionStateArray.first == nil
            @black_bar = UIView.alloc.initWithFrame(CGRectMake(0, 0, self.view.frame.size.width, 20))
            @black_bar.backgroundColor = UIColor.blackColor
            self.view.addSubview(@black_bar)
            createMap(@all_regions)
            self.view.bringSubviewToFront(@black_bar)
          end

          NSLog("Enabling region monitoring.")
        else
          NSLog("Warning: Region monitoring not supported on this device.")
        end
      else
        @location_manager = CLLocationManager.alloc.init
        @location_manager.startUpdatingLocation
        NSLog("Location services for this app not enabled")
        general_alert("Location services must be allowed for this application.")
      end
    else
      general_alert("Location services not enabled.")
      NSLog("Location services not enabled. FIX IT IN SETTINGS!")
    end

  end

  def initWithNibName(name, bundle: bundle)
    super
    @planet = UIImage.imageNamed('planet.png')
    @planetSel = UIImage.imageNamed('planet-select.png')
    self.tabBarItem = UITabBarItem.alloc.initWithTitle('Discover', image: @planet, tag: 1)
    self.tabBarItem.setFinishedSelectedImage(@planetSel, withFinishedUnselectedImage:@planet)
    self
  end

  def set_location_manager
    @location_manager = CLLocationManager.alloc.init
    @location_manager.desiredAccuracy = 1.0
    @location_manager.distanceFilter = 5
    @location_manager.delegate = self
    @location_manager.pausesLocationUpdatesAutomatically = false
    @location_manager.activityType = CLActivityTypeFitness
    @location_manager.startUpdatingLocation
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

  def populate_view_with_data(location_id)
    System.pull_system_data(location_id) do |system|

      @planetTitle = UILabel.alloc.initWithFrame(CGRectZero)
      @planetTitle.styleClass = 'h1'
      @planetTitle.text = system[:name]
      @planetTitle.sizeToFit
      @planetTitle.center = CGPointMake(self.view.frame.size.width / 2, 90)
      self.view.addSubview(@planetTitle)

      frame = UIScreen.mainScreen.applicationFrame
      origin = frame.origin
      size = frame.size
      body = UITextView.alloc.initWithFrame([[origin.x, origin.y + 100], [size.width, size.height]])
      body.styleClass = 'PlanetText'
      body.text = system[:description]
      body.backgroundColor = UIColor.clearColor
      body.editable = false

      scroll_view = UIScrollView.alloc.initWithFrame(frame)
      scroll_view.showsVerticalScrollIndicator = true
      scroll_view.scrollEnabled = true
      scroll_view.addSubview(body)
      scroll_view.backgroundColor = UIColor.clearColor
      scroll_view.contentSize = body.frame.size
      self.view.addSubview(scroll_view)
    end
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

  def locationManager(manager, didUpdateLocations:locations)
    @latitude = locations.last.coordinate.latitude
    @longitude = locations.last.coordinate.longitude
  end

  def locationManager(manager, didFailWithError:error)
    show_error_message('Enable the Location Services for this app in Settings.')
  end

  def locationManager(manager, didEnterRegion:region)
  end

  def locationManager(manager, didExitRegion:region)
    @defaults["user_location"] = nil
  end

  def locationManager(manager, monitoringDidFailForRegion:region, withError:error)
    general_alert(error)
  end

  def show_error_message(message)
    general_alert(message)
  end

  def display_lat_long
    general_alert("Lat: #{@latitude}, Long: #{@longitude}")
  end

  def general_alert(message)
    alert = UIAlertView.new
    alert.addButtonWithTitle("OK")
    alert.message = "#{message}"
    alert.show
  end
end

