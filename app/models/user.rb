class User
  PROPERTIES = [:id, :provider, :name, :username, :location]
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

  def self.visited_sites(payload, &block)
    BW::HTTP.post("http://tosche-station.herokuapp.com/users/mobile", {payload: payload}) do |response|
      visits_data = BW::JSON.parse(response.body.to_str)
      block.call(visits_data)
    end
  end
end
