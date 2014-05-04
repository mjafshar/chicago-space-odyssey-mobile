class GeoCachingController < UIViewController
  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.whiteColor
    @label = UILabel.alloc.initWithFrame(CGRectZero)
    self.title = "Geo Cache"
    @label.text = 'Geo Cached items'
    @label.sizeToFit
    @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
    self.view.addSubview(@label)

    @picture_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @picture_button.setTitle("Take A Pic", forState:UIControlStateNormal)
    @picture_button.frame = [[100, 100], [100, 50]]
    @picture_button.center = CGPointMake(self.view.frame.size.width / 2, @label.center.y + 40)
    self.view.addSubview @picture_button
    @view = self

    @picture_button.when(UIControlEventTouchUpInside) do
      take_picture
    end
  end

  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemDownloads, tag: 2)
    self
  end

  def take_picture
    BW::Device.camera.rear.picture(media_types: [:movie, :image]) do |result|
      image_view = UIImageView.alloc.initWithImage(result[:original_image])
      image = UIImage.UIImagePNGRepresentation(image_view.image)
      encodedImage = [image].pack('m0')
      data = {image: encodedImage, text: "Some text"}
      send_post_request(data)

    end
  end

  def send_post_request(payload)
    BW::HTTP.post("http://192.168.0.49:3000/collections/create", {payload: payload}) do |response|
    end
  end

  # def take_picture
  #   BW::Device.camera.any.picture(media_types: [:movie, :image]) do |result|
  #     image_view = UIImageView.alloc.initWithImage(result[:original_image])
  #   end
  # end
end
