class QuoteCell < PostCell

  def height
    75
  end

  def setupSubviewArray
    @blog_name = UILabel.alloc.initWithFrame(CGRectZero)
    @caption = UILabel.alloc.initWithFrame(CGRectZero)
    @type_img = UIImageView.alloc.initWithFrame(CGRectZero)

    [@blog_name, @caption, @type_img]
  end

  def updateViewsFromPost(post)
    @blog_name.frame = [[CELL_PADDING, CELL_PADDING], [150, 20]]
    @blog_name.text = post.blog_name
    @blog_name.setMinimumFontSize(16)
    @blog_name.setFont(UIFont.systemFontOfSize(16))

    constraint = CGSizeMake(CELL_WIDTH - (CELL_PADDING * 2), IMAGE_HEIGHT.to_f);
    size = post.text.sizeWithFont(UIFont.systemFontOfSize(12), constrainedToSize:constraint, lineBreakMode:UILineBreakModeWordWrap)

    @caption.text = post.text.gsub(/<\/?[^>]*>/, '')
    @caption.setLineBreakMode(UILineBreakModeWordWrap)
    @caption.setMinimumFontSize(12)
    @caption.setFont(UIFont.systemFontOfSize(12))
    @caption.frame = [[CELL_PADDING, height - CELL_PADDING - IMAGE_HEIGHT - 1], [CELL_WIDTH - (CELL_PADDING * 2), [IMAGE_HEIGHT - CELL_PADDING, size.height].max]]
    @caption.numberOfLines = 0

    @type_img.image = UIImage.imageWithContentsOfFile(App.resources_path + '/Quote.png')
    @type_img.frame = [[CELL_WIDTH - @type_img.image.size.width, 0], [@type_img.image.size.width, @type_img.image.size.height]]
  end

end
