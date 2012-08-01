class QuoteCell < PostCell

  def height
    75
  end

  def setupSubviewArray
    @blog_name = UILabel.alloc.initWithFrame(CGRectZero)
    @caption = UILabel.alloc.initWithFrame(CGRectZero)
    @type_img = UIImageView.alloc.initWithFrame(CGRectZero)
    @source = RCLabel.alloc.initWithFrame(CGRectZero)

    super + [@caption, @source]
  end

  def updateViewsFromPost(post)
    super

    text = ['"', post.text, '"'].join.gsub(/<\/?[^>]*>/, '')
    size = text.sizeWithFont(UIFont.fontWithName(post.font, size:24), constrainedToSize:[550, 500], lineBreakMode:UILineBreakModeWordWrap)

    @caption.text = text
    #@caption.setLineBreakMode(UILineBreakModeWordWrap)
    @caption.setMinimumFontSize(24)
    @caption.setFont(UIFont.fontWithName(post.font, size:24))
    @caption.backgroundColor = UIColor.clearColor
    @caption.opaque = false
    @caption.textAlignment = UITextAlignmentCenter
    @caption.numberOfLines = 0
    @caption.lineBreakMode = UILineBreakModeWordWrap
    @caption.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
    @caption.frame = [[self.frame.size.width / 2 - size.width / 2, 60], [size.width, size.height]]

    text = "<html><head></head><body  text=\"#333\" link=\"#0000aa\" style=\"background-color: transparent; font-family: Helvetica; font-size:14px; text-align:center;\">#{post.source}</body></html>"
    @source.componentsAndPlainText = RCLabel.extractTextStyle(text)
    @source.setOpaque(false)
    @source.setBackgroundColor(UIColor.clearColor)
    @source.textAlignment = KCTRightTextAlignment
    @source.delegate = self
    @source.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin

    opt_size = @source.optimumSize
    @source.frame = [[self.frame.size.width / 2 - size.width / 2, size.height + 70], [size.width, opt_size.height]]
  end

end
