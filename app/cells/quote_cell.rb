class QuoteCell < PostCell

  def height
    75
  end

  def setupSubviewArray
    @blog_name = UILabel.alloc.initWithFrame(CGRectZero)
    @caption = UILabel.alloc.initWithFrame(CGRectZero)
    @type_img = UIImageView.alloc.initWithFrame(CGRectZero)

    super + [@caption]
  end

  def updateViewsFromPost(post)
    super

    text = ['"', post.text, '"'].join.gsub(/<\/?[^>]*>/, '')
    size = text.sizeWithFont(UIFont.fontWithName("AmericanTypewriter", size:24), constrainedToSize:[550, 500], lineBreakMode:UILineBreakModeWordWrap)

    @caption.text = text
    #@caption.setLineBreakMode(UILineBreakModeWordWrap)
    @caption.setMinimumFontSize(24)
    @caption.setFont(UIFont.fontWithName("AmericanTypewriter", size:24))
    @caption.backgroundColor = UIColor.clearColor
    @caption.opaque = false
    @caption.textAlignment = UITextAlignmentCenter
    @caption.numberOfLines = 0
    @caption.lineBreakMode = UILineBreakModeWordWrap
    @caption.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
    @caption.frame = [[self.frame.size.width / 2 - size.width / 2, 60], [size.width, size.height]]
  end

end
