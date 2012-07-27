class PhotoView < PostView

  def displayContent
    @img = UIImageView.alloc.initWithFrame(CGRectZero)
    @img.contentMode = UIViewContentModeScaleAspectFit

    width = @post.photos[0]['alt_sizes'][1]['width']
    height = @post.photos[0]['alt_sizes'][1]['height']
    @img.frame = [[self.frame.size.width / 2 - width / 2, 10], [width, height]]

    @img.image = UIImage.imageWithData(NSData.dataWithContentsOfURL(NSURL.URLWithString(@post.photos[0]['alt_sizes'][1]['url'])))
    addSubview(@img)

    unless @post.caption.empty?
      text = "<html><head></head><body  text=\"#333\" link=\"#0000aa\" style=\"background-color: transparent; font-family: Helvetica; font-size:14px; text-align:center;\">#{@post.caption}</body></html>"
      @web_view = UIWebView.alloc.init
      @web_view.setOpaque(false)
      @web_view.setBackgroundColor(UIColor.clearColor);
      @web_view.loadHTMLString(text, baseURL:nil)
      @web_view.frame = [[self.frame.size.width / 2 - width / 2, height + 20], [width, 200]]
      @web_view.scrollView.scrollEnabled = false
      @web_view.scrollView.bounces = false
      @web_view.delegate = self

      addSubview(@web_view)
    end
  end

  def webView(webView, shouldStartLoadWithRequest:request, navigationType:navigationType)
    if request.URL.scheme.downcase != 'about'
      p request.URL.absoluteString
    end
    request.URL.scheme == "about"
  end

end
