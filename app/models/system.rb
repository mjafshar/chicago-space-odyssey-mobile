class System
  PROPERTIES = [:name, :description, :url, :image_path, :location_id, :created_at, :updated_at]
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

  def self.pull_system_data(system_id)
    BW::HTTP.get("http://192.168.0.9:3000/locations/#{system_id}") do |response|
      result_data = BW::JSON.parse(response.body.to_str)
      puts "result_data"
      @system_data = result_data[:system]
      puts "Inside: #{@system_data}"
      # if system.id.to_id == -1
      #   block.call(nil)
      # else
      #   block.call(system)
      # end

      # p response.body.to_str
      # block.call(nil)
    end
    puts "Outside: #{@system_data}"
  end
end
