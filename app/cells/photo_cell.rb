class PhotoCell < PostCell

  def height
    80
  end

  def setupSubviewArray
    @img = UIImageView.alloc.initWithFrame(CGRectZero)
    @web_view = UIWebView.alloc.init
    @header_block = UIView.alloc.initWithFrame(CGRectZero)
    @blog_name = UILabel.alloc.initWithFrame(CGRectZero)
    @avatar_img = UIImageView.alloc.initWithFrame(CGRectZero)
    @post_time = UILabel.alloc.initWithFrame(CGRectZero)

    [@img, @web_view, @header_block, @blog_name, @avatar_img, @post_time]
  end

  def updateViewsFromPost(post)
    @img.contentMode = UIViewContentModeScaleAspectFit

    width = post.photos[0]['alt_sizes'][1]['width']
    height = post.photos[0]['alt_sizes'][1]['height']
    @img.frame = [[self.frame.size.width / 2 - width / 2, 60], [width, height]]
    @img.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin

    url = post.photos[0]['alt_sizes'][1]['url']
    @img.setImageWithURL(NSURL.URLWithString(url, placeholderImage:UIImage.imageNamed("placeholder.png")))

    unless post.caption.empty?
      text = "<html><head></head><body  text=\"#333\" link=\"#0000aa\" style=\"background-color: transparent; font-family: Helvetica; font-size:14px; text-align:center;\">#{post.caption}</body></html>"
      @web_view.setOpaque(false)
      @web_view.setBackgroundColor(UIColor.clearColor);
      @web_view.loadHTMLString(text, baseURL:nil)
      @web_view.frame = [[self.frame.size.width / 2 - width / 2, height + 70], [width, 200]]
      @web_view.scrollView.scrollEnabled = false
      @web_view.scrollView.bounces = false
      @web_view.delegate = self
      @web_view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
    end

    @header_block.frame = [[0, 0], [@header_block.superview.frame.size.width, 50]]
    @header_block.backgroundColor = UIColor.whiteColor

    size = post.blog_name.sizeWithFont(UIFont.systemFontOfSize(16))
    @blog_name.frame = [[52, 0], [size.width, size.height]]
    @blog_name.text = post.blog_name
    @blog_name.setLineBreakMode(UILineBreakModeWordWrap)
    @blog_name.setMinimumFontSize(16)
    @blog_name.setFont(UIFont.systemFontOfSize(16))
    @blog_name.numberOfLines = 0

    post_date = "Posted: " + Time.at(post.timestamp).strftime('%B %d, %Y %I:%M %p')
    size = post_date.sizeWithFont(UIFont.systemFontOfSize(14))
    @post_time.frame = [[52, 50 - size.height - 1], [size.width, size.height]]
    @post_time.text = post_date
    @post_time.setLineBreakMode(UILineBreakModeWordWrap)
    @post_time.setMinimumFontSize(14)
    @post_time.setFont(UIFont.systemFontOfSize(14))
    @post_time.numberOfLines = 0

    @avatar_img.frame = [[1, 1], [48, 48]]
    url = "http://api.tumblr.com/v2/blog/#{post.blog_name}.tumblr.com/avatar/48"
    @avatar_img.setImageWithURL(NSURL.URLWithString(url, placeholderImage:UIImage.imageNamed("placeholder.png")))
    # self.retain
    # BubbleWrap::HTTP.get("http://api.tumblr.com/v2/blog/#{post.blog_name}.tumblr.com/avatar/48") do |response|
    #     @avatar_img.image = UIImage.imageWithData(response.body)
    #     self.release
    # end
  end

  def webViewDidFinishLoad(webView)
    # fitting_size = webView.sizeThatFits(CGSizeZero)
    # webView.frame.size = fitting_size
    # p webView.frame
  end

end
