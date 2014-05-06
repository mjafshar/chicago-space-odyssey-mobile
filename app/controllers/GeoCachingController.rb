class GeoCachingController < UIViewController
  def viewDidLoad
    super
    @defaults = NSUserDefaults.standardUserDefaults
    frame = UIScreen.mainScreen.applicationFrame
    origin = frame.origin
    size = frame.size

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

      body = UITextView.alloc.initWithFrame([[origin.x, origin.y + 20], [size.width, size.height]])
      body.text = "Share your thoughts and photos."

      finished_btn = UIButton.buttonWithType(UIButtonTypeCustom)
      finished_btn.setTitle("Finished", forState: UIControlStateNormal)
      finished_btn.addTarget(self, action: 'hide_message_composer', forControlEvents: UIControlEventTouchUpInside)
      finished_btn.center = CGPointMake(250, 0)
      finished_btn.sizeToFit

      # cancel_btn = UIButton.buttonWithType(UIButtonTypeCustom)
      # cancel_btn.setTitle("Cancel", forState:UIControlStateNormal)
      # cancel_btn.center = CGPointMake(10, 0)
      # cancel_btn.addTarget(self, action: 'cancel_message_composer', forControlEvents: UIControlEventTouchUpInside)
      # cancel_btn.sizeToFit

      keyboard_toolbar = UIView.alloc.initWithFrame(CGRectMake(10, 0, size.width, 40))
      keyboard_toolbar.backgroundColor = UIColor.lightGrayColor
      # keyboard_toolbar.addSubview(finished_btn)
      # keyboard_toolbar.addSubview(cancel_btn)

      @composer_text_view = UITextView.alloc.initWithFrame([[origin.x, origin.y + 20], [self.view.frame.size.width, self.view.frame.size.height - 10]])
      @composer_text_view.inputAccessoryView = keyboard_toolbar
      @composer_text_view.scrollEnabled = 'YES'
      @composer_text_view.text = "Type something"
      @composer_text_view.textAlignment = UITextAlignmentCenter

      spacer = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target:nil, action:nil)
      cancel_btn = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemCancel, target:self, action:'cancel_message_composer')
      picture_btn = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemCamera, target:self, action:'take_picture')
      submit_btn = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemDone, target:self, action:'submit')

      toolbar = UIToolbar.alloc.initWithFrame(CGRectMake(0, 0, 320, 40))
      toolbar.setItems([cancel_btn, spacer, picture_btn, spacer, submit_btn], animated: true)
      # self.view.addSubview(toolbar)
      keyboard_toolbar.addSubview(toolbar)
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
    @composer_text_view.becomeFirstResponder
  end

  def hide_message_composer
    @composer_text_view.removeFromSuperview
  end

  def cancel_message_composer
    hide_message_composer
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
    BW::HTTP.post("http://192.168.0.106:3000/collections/create", {payload: payload}) do |response|
    end
  end

  def submit
    @data[:text] = @composer_text_view.text
    @data[:image] = encode_image(@image_view)
    send_post_request(@data)
    cancel_message_composer

    # How to close view on submit
  end
end

# /locations/:id/collections
#
# Add cancel upload
# Always show keyboard
