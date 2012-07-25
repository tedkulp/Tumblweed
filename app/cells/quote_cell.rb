class QuoteCell < PostCell

  def height
    75
  end

  def setupSubviewArray
    @blog_name = UILabel.alloc.initWithFrame([[5, 5], [320 - 10, 20]])
    @caption = UILabel.alloc.initWithFrame(CGRectZero)
    @caption.setLineBreakMode(UILineBreakModeWordWrap)
    @caption.setMinimumFontSize(12)
    @caption.setFont(UIFont.systemFontOfSize(12))
    [@blog_name, @caption]
  end

  def updateViewsFromPost(post)
    @blog_name.text = post.blog_name

    constraint = CGSizeMake(320 - (5 * 2), 20000.0);
    size = post.text.sizeWithFont(UIFont.systemFontOfSize(12), constrainedToSize:constraint, lineBreakMode:UILineBreakModeWordWrap)

    @caption.text = post.text.gsub(/<\/?[^>]*>/, '')
    @caption.setFrame(CGRectMake(5, 25, 320 - (5 * 2), [size.height, 67 - 25].max))
    @caption.numberOfLines = 0
    @caption.sizeToFit
  end

end
