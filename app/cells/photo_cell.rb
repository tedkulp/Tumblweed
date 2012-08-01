class PhotoCell < PostCell

  def height
    80
  end

  def setupSubviewArray
    @img = UIImageView.alloc.initWithFrame(CGRectZero)
    @web_view = RCLabel.alloc.initWithFrame(CGRectZero)

    super + [@img, @web_view]
  end

  def prepareForReuse
    @web_view.componentsAndPlainText = RCLabel.extractTextStyle('')
  end

  def updateViewsFromPost(post)
    super

    @img.contentMode = UIViewContentModeScaleAspectFit

    width = post.photos[0]['alt_sizes'][1]['width']
    height = post.photos[0]['alt_sizes'][1]['height']
    @img.frame = [[self.frame.size.width / 2 - width / 2, 60], [width, height]]
    @img.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin

    url = post.photos[0]['alt_sizes'][1]['url']
    @img.setImageWithURL(NSURL.URLWithString(url, placeholderImage:UIImage.imageNamed("placeholder.png")))

    unless post.caption.empty?
      text = "<html><head></head><body  text=\"#333\" link=\"#0000aa\" style=\"background-color: transparent; font-family: Helvetica; font-size:14px; text-align:center;\">#{post.caption}</body></html>"
      @web_view.componentsAndPlainText = RCLabel.extractTextStyle(text)
      @web_view.setOpaque(false)
      @web_view.setBackgroundColor(UIColor.clearColor)
      @web_view.textAlignment = KCTCenterTextAlignment
      @web_view.delegate = self
      @web_view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin

      opt_size = @web_view.optimumSize
      @web_view.frame = [[self.frame.size.width / 2 - width / 2, height + 70], [width, opt_size.height]]
    end

  end

  def webViewDidFinishLoad(webView)
    fitting_size = webView.sizeThatFits(CGSizeZero)
    webView.frame.size = fitting_size
    p webView.frame
  end

end
