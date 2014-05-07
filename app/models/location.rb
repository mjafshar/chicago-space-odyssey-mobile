class Location
  PROPERTIES = [:name, :latitude, :longitude]
  PROPERTIES.each { |prop|
    attr_accessor prop
  }

  def initialize(hash = {})
    hash.each { |key, value|
      if PROPERTIES.member? key.to_sym
        self.send((key.to_s + "=").to_s, value)
      end
    }
  end

  def self.all_regions
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
  end

end