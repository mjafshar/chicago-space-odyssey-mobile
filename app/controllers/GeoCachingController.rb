class GeoCachingController < UIViewController
  def viewDidLoad
    super

    @defaults = NSUserDefaults.standardUserDefaults
    NSLog("========================================")
    NSLog("The user location in GeoCachingController: #{@defaults['user_location']}")
    NSLog("The user twitter id in GeoCachingController: #{@defaults['twitter_id']}")

    frame = UIScreen.mainScreen.applicationFrame
    origin = frame.origin

    self.view.backgroundColor = UIColor.whiteColor
    self.title = "Geo Cache"

    compose_btn = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    compose_btn.setTitle("Compose", forState: UIControlStateNormal)
    compose_btn.addTarget(self, action: 'show_message_composer', forControlEvents:UIControlEventTouchUpInside)
    compose_btn.sizeToFit
    compose_btn.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
    self.view.addSubview(compose_btn)

    submit_btn = UIButton.buttonWithType(UIButtonTypeCustom)
    submit_btn.setTitle("Submit", forState: UIControlStateNormal)
    submit_btn.setTitle("Sending", forState: UIControlStateHighlighted)
    submit_btn.addTarget(self, action: 'submit', forControlEvents: UIControlEventTouchUpInside)
    submit_btn.center = CGPointMake(250, 0)
    submit_btn.sizeToFit

    picture_btn = UIButton.buttonWithType(UIButtonTypeCustom)
    picture_btn.setTitle("Take A Pic", forState:UIControlStateNormal)
    picture_btn.addTarget(self, action: 'take_picture', forControlEvents: UIControlEventTouchUpInside)
    picture_btn.center = CGPointMake(10, 0)
    picture_btn.sizeToFit

    toolbar = UIView.alloc.initWithFrame(CGRectMake(10, 0, 310, 40))
    toolbar.backgroundColor = UIColor.lightGrayColor

    toolbar.addSubview(picture_btn)
    toolbar.addSubview(submit_btn)

    @composer_text_view = UITextView.alloc.initWithFrame([[origin.x, origin.y + 20], [self.view.frame.size.width, self.view.frame.size.height - 10]])
    @composer_text_view.inputAccessoryView = toolbar
    @composer_text_view.scrollEnabled = 'YES'
    @composer_text_view.text = "Type something"
    @composer_text_view.textAlignment = UITextAlignmentCenter
  end

  def textFieldShouldReturn(textField)
    textField.resignFirstResponder
    true
  end

  def show_message_composer
    self.view.addSubview(@composer_text_view)
  end

  def hide_message_composer
    @composer_text_view.removeFromSuperview
  end

  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemDownloads, tag: 2)
    self
  end

  def take_picture
    # Have picture process in background
    BW::Device.camera.rear.picture(media_types: [:movie, :image]) do |result|
      @image_view = UIImageView.alloc.initWithImage(result[:original_image])
      @image_view
    end
  end

  def encode_image(image_view)
    if image_view != nil
      image = UIImage.UIImagePNGRepresentation(image_view.image)
      encodedImage = [image].pack('m0')
      return encodedImage
    else
      return nil
    end
  end

  def send_post_request(payload)
    # Have sending process in background, when phone is turned off or app is in background
    BW::HTTP.post("http://192.168.0.90:3000/collections/create", {payload: payload}) do |response|
    end
  end

  def submit
    account = Twitter.accounts[0]
    user_id = account.user_id
    puts @composer_text_view.text
    # textFieldShouldReturn(@composer_text_view)
    data = {}
    data = {image: encode_image(@image_view), text: @composer_text_view.text, user_id: user_id}
    data[:text] ||= ''
    data[:image] ||= ''
    hide_message_composer
    send_post_request(data)
    @image_view = nil
    @composer_text_view.text = 'Type something'
    # view.removeSubview(@composer_text_view)
    # How to close view on submit
  end

  # def take_picture
  #   BW::Device.camera.any.picture(media_types: [:movie, :image]) do |result|
  #     image_view = UIImageView.alloc.initWithImage(result[:original_image])
  #   end
  # end
end

# /locations/:id/collections
