class GeoCachingController < UIViewController
  def viewDidLoad
    super
    view.styleId = 'GeoCacheView'

    @defaults = NSUserDefaults.standardUserDefaults
    frame = UIScreen.mainScreen.applicationFrame
    origin = frame.origin
    size = frame.size

    if @defaults['user_location'] != nil

      @data = {image: nil, text: nil, user_id: @defaults['twitter_id'], location_id: @defaults['user_location']}

      system_name = @defaults["system_name"]
      system_distance = @defaults["system_distance"]
      system_description = @defaults["system_description"]

      @planetTitle = UILabel.alloc.initWithFrame(CGRectZero)
      @planetTitle.styleClass = 'h1'
      @planetTitle.text = system_name
      @planetTitle.sizeToFit
      @planetTitle.center = CGPointMake(self.view.frame.size.width / 2, 90)
      self.view.addSubview(@planetTitle)

      @body = UITextView.alloc.initWithFrame([[origin.x, origin.y + 100], [size.width, size.height]])
      @body.backgroundColor = UIColor.clearColor
      @body.text = "#{system_name} is #{system_distance} light years from our solar system. That means the light from #{system_name} that we observe is #{system_distance} years old."
      @body.editable = false
      @body.styleId = 'GeoBody'
      self.view.addSubview(@body)

      @action_call = UITextView.alloc.initWithFrame([[origin.x, origin.y + 370], [size.width, size.height]])
      @action_call.backgroundColor = UIColor.clearColor
      @action_call.text = "Tell us what you were doing #{system_distance} years ago."
      @action_call.editable = false
      @action_call.styleId = 'ActionCallLabel'
      self.view.addSubview(@action_call)


      @compose_btn = UIButton.buttonWithType(UIButtonTypeRoundedRect)
      @compose_btn.setTitle("Compose", forState: UIControlStateNormal)
      @compose_btn.setFont(UIFont.fontWithName('Avenir Next', size:22))
      @compose_btn.addTarget(self, action: 'show_message_composer', forControlEvents:UIControlEventTouchUpInside)
      @compose_btn.center = CGPointMake(20, size.height - 120)
      self.view.addSubview(@compose_btn)

      keyboard_toolbar = UIView.alloc.initWithFrame(CGRectMake(10, 0, size.width, 40))

      @composer_text_view = UITextView.alloc.initWithFrame([[origin.x, origin.y + 20], [size.width, 270]])
      @composer_text_view.backgroundColor = UIColor.blackColor
      @composer_text_view.inputAccessoryView = keyboard_toolbar
      @composer_text_view.scrollEnabled = true
      @composer_text_view.setFont(UIFont.fontWithName('Avenir Next', size:18))

      spacer = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target:nil, action:nil)
      cancel_btn = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemCancel, target:self, action:'cancel_message_composer')
      picture_btn = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemCamera, target:self, action:'take_picture')
      submit_btn = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemDone, target:self, action:'submit')

      toolbar = UIToolbar.alloc.initWithFrame(CGRectMake(0, 0, 320, 40))
      toolbar.setItems([cancel_btn, spacer, picture_btn, spacer, submit_btn], animated: true)

      keyboard_toolbar.addSubview(toolbar)

    else
      @label = UILabel.alloc.initWithFrame(CGRectZero)

      @label.text = 'Too far away from any systems'
      @label.sizeToFit

      @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
      @label.styleClass = 'message'

      self.view.addSubview(@label)
    end
  end

  def initWithNibName(name, bundle: bundle)
    super
    @write = UIImage.imageNamed('write.png')
    @writeSel = UIImage.imageNamed('write-select.png')
    self.tabBarItem = UITabBarItem.alloc.initWithTitle('Share', image: @write, tag: 2)
    self.tabBarItem.setFinishedSelectedImage(@writeSel, withFinishedUnselectedImage:@write)
    self
  end

  def show_message_composer
    self.view.addSubview(@composer_text_view)
    @compose_btn.removeFromSuperview
    @body.removeFromSuperview
    @action_call.removeFromSuperview
    @planetTitle.removeFromSuperview
    @composer_text_view.becomeFirstResponder
  end

  def hide_message_composer
    @composer_text_view.removeFromSuperview
  end

  def cancel_message_composer
    hide_message_composer
    @image_view = nil
    @composer_text_view.text = ''
    self.view.addSubview(@body)
    self.view.addSubview(@action_call)
    self.view.addSubview(@planetTitle)
    self.view.addSubview(@compose_btn)
  end

  def take_picture
    BW::Device.camera.rear.picture(media_types: [:image]) do |result|
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

  def submit
    @data[:text] = @composer_text_view.text
    @data[:image] = encode_image(@image_view)
    send_messege(@data)
    cancel_message_composer
  end

  def send_messege(payload)
    # Have sending process in background, when phone is turned off or app is in background
    BW::HTTP.post("http://tosche-station.herokuapp.com/collections/create", {payload: payload}) do |response|
      if response
        alert = UIAlertView.new
        alert.addButtonWithTitle("OK")
        alert.message = "Message posted!"
        alert.show
      end
    end
  end
end
