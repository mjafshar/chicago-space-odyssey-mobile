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
    @picture_button.sizeToFit
    # @picture_button.center = CGPointMake(self.view.frame.size.width / 2, @text_field.center.y + 40)
    self.view.addSubview @picture_button

    @picture_button.when(UIControlEventTouchUpInside) do
      # @picture_button.enabled = false

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
    end
  end

  # def take_picture
  #   BW::Device.camera.any.picture(media_types: [:movie, :image]) do |result|
  #     image_view = UIImageView.alloc.initWithImage(result[:original_image])
  #   end
  # end
end
