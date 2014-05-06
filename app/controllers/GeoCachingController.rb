class GeoCachingController < UIViewController
  def viewDidLoad
    super
    @defaults = NSUserDefaults.standardUserDefaults
    frame = UIScreen.mainScreen.applicationFrame
    origin = frame.origin

    self.view.backgroundColor = UIColor.whiteColor

    if @defaults['user_location'] != nil
      self.title = "Geo Cache"

    @data = {image: nil, text: nil, user_id: @defaults['twitter_id'], location_id: @defaults['user_location']}

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
    picture_btn.center = CGPointMake(125, 0)
    picture_btn.sizeToFit

    cancel_btn = UIButton.buttonWithType(UIButtonTypeCustom)
    cancel_btn.setTitle("Cancel", forState:UIControlStateNormal)
    cancel_btn.addTarget(self, action: 'hide_message_composer', forControlEvents: UIControlEventTouchUpInside)
    cancel_btn.center = CGPointMake(10, 0)
    cancel_btn.sizeToFit

    toolbar = UIView.alloc.initWithFrame(CGRectMake(10, 0, 310, 40))
    toolbar.backgroundColor = UIColor.lightGrayColor

    toolbar.addSubview(picture_btn)
    toolbar.addSubview(submit_btn)
    toolbar.addSubview(cancel_btn)

    @composer_text_view = UITextView.alloc.initWithFrame([[origin.x, origin.y + 20], [self.view.frame.size.width, self.view.frame.size.height - 10]])
    @composer_text_view.inputAccessoryView = toolbar
    @composer_text_view.scrollEnabled = 'YES'
    @composer_text_view.text = "Type something"
    @composer_text_view.textAlignment = UITextAlignmentCenter

    @toolbar = UIToolbar.new
    @toolbar.barStyle = UIBarStyleDefault
    height = UIScreen.mainScreen.bounds.size.height
    width = UIScreen.mainScreen.bounds.size.width
    @toolbar.frame = CGRect.new [0, height - 32], [width, 32]

    # Add standard button for enabling location tracking

    @toolbar.setItems [cancel_btn, picture_btn, submit_btn]
    view.addSubview @toolbar
    else
      @label = UILabel.alloc.initWithFrame(CGRectZero)
      self.title = "Out of Range"
      @label.text = 'Too far away from any systems'
      @label.sizeToFit
      @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
      self.view.addSubview(@label)
    end
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
    @image_view = nil
    @composer_text_view.text = 'Type something'
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
    @data[:text] = @composer_text_view.text
    @data[:image] = encode_image(@image_view)
    hide_message_composer
    send_post_request(@data)

    # How to close view on submit
  end
end

# /locations/:id/collections
#
# Add cancel upload
# Always show keyboard
