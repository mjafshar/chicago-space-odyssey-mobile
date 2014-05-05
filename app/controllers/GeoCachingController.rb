class GeoCachingController < UIViewController
  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.whiteColor
    # @label = UILabel.alloc.initWithFrame(CGRectZero)
    # self.title = "Geo Cache"
    # @label.text = 'Geo Cached items'
    # @label.sizeToFit
    # @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
    # self.view.addSubview(@label)


    @customTextbox = UITextView.alloc.initWithFrame(self.view.bounds)
    toolbar = UIView.alloc.initWithFrame(CGRectMake(10, 0, 310, 40))
    submit = UIButton.buttonWithType(UIButtonTypeCustom)
    picture_button = UIButton.buttonWithType(UIButtonTypeCustom)

    toolbar.backgroundColor = UIColor.lightGrayColor

    submit.setTitle("Submit", forState:UIControlStateNormal)
    submit.addTarget(self, action: 'submit', forControlEvents: UIControlEventTouchUpInside)
    submit.center = CGPointMake(250, 0)
    submit.sizeToFit

    picture_button.setTitle("Take A Pic", forState:UIControlStateNormal)
    picture_button.addTarget(self, action: 'take_picture', forControlEvents: UIControlEventTouchUpInside)
    picture_button.center = CGPointMake(10, 0)
    picture_button.sizeToFit
    # picture_button.frame = [[100, 100], [100, 50]]
    # picture_button.center = CGPointMake(self.view.frame.size.width / 2, @label.center.y + 40)

    toolbar.addSubview(picture_button)
    toolbar.addSubview(submit)

    @customTextbox.inputAccessoryView = toolbar
    @customTextbox.text = "Type.."
    @customTextbox.textAlignment = UITextAlignmentCenter

    view.addSubview(@customTextbox)

    # picture_button.when(UIControlEventTouchUpInside) do
    #   take_picture
    # end
  end

  def textFieldShouldReturn(textField)
    textField.resignFirstResponder
    true
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
    image = UIImage.UIImagePNGRepresentation(image_view.image)
    encodedImage = [image].pack('m0')
    encodedImage
  end

  def send_post_request(payload)
    # Have sending process in background
    BW::HTTP.post("http://tosche-station.herokuapp.com/collections/create", {payload: payload}) do |response|
    end
  end

  def submit
    puts @customTextbox.text
    textFieldShouldReturn(@customTextbox)
    data = {image: encode_image(@image_view), text: @customTextbox.text}
    # send_post_request(data)
    # How to close view on submit
  end

  # def take_picture
  #   BW::Device.camera.any.picture(media_types: [:movie, :image]) do |result|
  #     image_view = UIImageView.alloc.initWithImage(result[:original_image])
  #   end
  # end
end
