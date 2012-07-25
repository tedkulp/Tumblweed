class PhotoCell < PostCell

  def height
    67
  end

  def setupSubviewArray
    @img = UIImageView.alloc.initWithFrame([[320 - 64 - 1, 1], [64, 64]])
    @blog_name = UILabel.alloc.initWithFrame([[5, 5], [320 - 64 - 1, 20]])
    @caption = UILabel.alloc.initWithFrame(CGRectZero)
    @caption.setLineBreakMode(UILineBreakModeWordWrap)
    @caption.setMinimumFontSize(12)
    @caption.setFont(UIFont.systemFontOfSize(12))
    [@img, @blog_name, @caption]
  end

  def updateViewsFromPost(post)
    @img.image = UIImage.imageWithData(NSData.dataWithContentsOfURL(NSURL.URLWithString(post.photos[0]['alt_sizes'].last['url'])))
    @blog_name.text = post.blog_name

    constraint = CGSizeMake(320 - (5 * 2) - 65, 20000.0);
    size = post.caption.sizeWithFont(UIFont.systemFontOfSize(12), constrainedToSize:constraint, lineBreakMode:UILineBreakModeWordWrap)

    @caption.text = post.caption.gsub(/<\/?[^>]*>/, '')
    @caption.setFrame(CGRectMake(5, 25, 320 - (5 * 2) - 65, [size.height, 67 - 25].max))
    @caption.numberOfLines = 0
    @caption.sizeToFit
  end

end
