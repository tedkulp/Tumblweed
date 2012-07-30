class PhotoCell < PostCell

  def height
    80
  end

  def setupSubviewArray
    @img = UIImageView.alloc.initWithFrame(CGRectZero)
    @web_view = UIWebView.alloc.init

    [@img, @web_view]
  end

  def updateViewsFromPost(post)
    @img.contentMode = UIViewContentModeScaleAspectFit

    width = post.photos[0]['alt_sizes'][1]['width']
    height = post.photos[0]['alt_sizes'][1]['height']
    @img.frame = [[self.frame.size.width / 2 - width / 2, 10], [width, height]]
    @img.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin

    url = post.photos[0]['alt_sizes'][1]['url']
    loadImageFromUrl(url, onComplete:lambda { |data| @img.image = UIImage.imageWithData(data) })

    unless post.caption.empty?
      text = "<html><head></head><body  text=\"#333\" link=\"#0000aa\" style=\"background-color: transparent; font-family: Helvetica; font-size:14px; text-align:center;\">#{post.caption}</body></html>"
      @web_view.setOpaque(false)
      @web_view.setBackgroundColor(UIColor.clearColor);
      @web_view.loadHTMLString(text, baseURL:nil)
      @web_view.frame = [[self.frame.size.width / 2 - width / 2, height + 20], [width, 200]]
      @web_view.scrollView.scrollEnabled = false
      @web_view.scrollView.bounces = false
      @web_view.delegate = self
      @web_view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
    end
  end

  def loadImageFromUrl(address, onComplete:block)
    self.retain
    if block
      block.retain
    end

    #@queue.async do
    Dispatch::Queue.concurrent.async do
      begin
        err = Pointer.new_with_type "@"
        url = NSURL.URLWithString address

        raise "Loading Error: #{err[0].description}" unless data = NSData.alloc.initWithContentsOfURL(url, options:0, error:err)

        if block
          Dispatch::Queue.main.sync do
            block.call(data)
            block.release
            self.release
          end
        end
      end
    end
  end

  def webViewDidFinishLoad(webView)
    # fitting_size = webView.sizeThatFits(CGSizeZero)
    # webView.frame.size = fitting_size
    # p webView.frame
  end

end
