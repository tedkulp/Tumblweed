class PhotoCell < PostCell

  def height
    80
  end

  def setupSubviewArray
    @img = UIImageView.alloc.initWithFrame(CGRectZero)
    @blog_name = UILabel.alloc.initWithFrame(CGRectZero)
    @caption = UILabel.alloc.initWithFrame(CGRectZero)
    @type_img = UIImageView.alloc.initWithFrame(CGRectZero)

    [@img, @blog_name, @caption, @type_img]
  end

  def updateViewsFromPost(post)
    @blog_name.frame = [[CELL_PADDING, CELL_PADDING], [150, 20]]
    @blog_name.text = post.blog_name
    @blog_name.setMinimumFontSize(16)
    @blog_name.setFont(UIFont.systemFontOfSize(16))

    @img.frame = [[CELL_PADDING, height - CELL_PADDING - IMAGE_HEIGHT - 1], [IMAGE_HEIGHT, IMAGE_HEIGHT]]
    @img.contentMode = UIViewContentModeScaleAspectFit
    @img.image = UIImage.imageWithData(NSData.dataWithContentsOfURL(NSURL.URLWithString(post.photos[0]['alt_sizes'].last['url'])))

    constraint = CGSizeMake(CELL_WIDTH - @img.frame.size.width - (CELL_PADDING * 2), IMAGE_HEIGHT.to_f);
    size = post.caption.sizeWithFont(UIFont.systemFontOfSize(13), constrainedToSize:constraint, lineBreakMode:UILineBreakModeWordWrap)

    @caption.text = post.caption.gsub(/<\/?[^>]*>/, '')
    @caption.setMinimumFontSize(13)
    @caption.setFont(UIFont.systemFontOfSize(13))
    @caption.sizeToFit
    @caption.frame = [[@img.frame.size.width + CELL_PADDING + CELL_PADDING, height - CELL_PADDING - IMAGE_HEIGHT - 1], [CELL_WIDTH - @img.frame.size.width + CELL_PADDING, IMAGE_HEIGHT]]
    @caption.numberOfLines = 0

    @type_img.image = UIImage.imageWithContentsOfFile(App.resources_path + '/Photo.png')
    @type_img.frame = [[CELL_WIDTH - @type_img.image.size.width, 0], [@type_img.image.size.width, @type_img.image.size.height]]
  end

end
