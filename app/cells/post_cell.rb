class PostCell < UITableViewCell
  attr_accessor :post
  attr_accessor :width

  CELL_PADDING = 2
  IMAGE_HEIGHT = 50

  def self.createCellWithTableView(tableView, withPost:post)
    cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)
    if cell.nil?
      cell = alloc.initWithFrame(CGRectZero)
      cell.selectionStyle = UITableViewCellSelectionStyleNone
    end
    cell.updateViewsFromPost(post)
    cell
  end

  # Protocol for getting height
  def cellHeightForContentWidth(contentWidth, withPost:post)
    updateViewsFromPost(post)
    subviews.flatten.collect { |a_view|
      a_view.frame.origin.y + a_view.frame.size.height
    }.max + 10
  end

  def self.reuseIdentifier
    to_s
  end

  def height
    50
  end

  def width
    @width || 0
  end

  def initWithFrame(frame)
    if super
      setDefaultFrame
      addSubviews(mySubviews)
    end
    self
  end

  def setDefaultFrame
    frame = [[0, 0], [height, width]]
  end

  def addSubviews(*views)
    views.flatten.each { |view| addSubview(view) }
  end

  def mySubviews
    @mySubviews ||= begin
      setupSubviewArray
    end
  end

  def setupSubviewArray
    @header_block = UIView.alloc.initWithFrame(CGRectZero)
    @blog_name = UILabel.alloc.initWithFrame(CGRectZero)
    @avatar_img = UIImageView.alloc.initWithFrame(CGRectZero)
    @post_time = UILabel.alloc.initWithFrame(CGRectZero)

    [@header_block, @blog_name, @avatar_img, @post_time]
  end

  def prepareForReuse
    #Not sure if we'll need this later
  end

  def updateViewsFromPost(post)
    @header_block.frame = [[0, 0], [@header_block.superview.frame.size.width, 48]]
    @header_block.backgroundColor = UIColor.whiteColor
    @header_block.autoresizingMask = UIViewAutoresizingFlexibleWidth

    size = post.blog_name.sizeWithFont(UIFont.systemFontOfSize(16))
    @blog_name.frame = [[50, 0], [size.width, size.height]]
    @blog_name.text = post.blog_name
    @blog_name.setLineBreakMode(UILineBreakModeWordWrap)
    @blog_name.setMinimumFontSize(16)
    @blog_name.setFont(UIFont.systemFontOfSize(16))
    @blog_name.numberOfLines = 0

    post_date = "Posted: " + Time.at(post.timestamp).strftime('%B %d, %Y %I:%M %p')
    size = post_date.sizeWithFont(UIFont.systemFontOfSize(14))
    @post_time.frame = [[50, 48 - size.height - 1], [size.width, size.height]]
    @post_time.text = post_date
    @post_time.setLineBreakMode(UILineBreakModeWordWrap)
    @post_time.setMinimumFontSize(14)
    @post_time.setFont(UIFont.systemFontOfSize(14))
    @post_time.numberOfLines = 0

    @avatar_img.frame = [[0, 0], [48, 48]]
    url = "http://api.tumblr.com/v2/blog/#{post.blog_name}.tumblr.com/avatar/48"
    @avatar_img.setImageWithURL(NSURL.URLWithString(url, placeholderImage:UIImage.imageNamed("placeholder.png")))
  end

  def layoutSubviews
    super
  end

  def setSelected(selected, animated:animated)
    super
  end

  def reuseIdentifier
    self.class.reuseIdentifier
  end

  def rtLabel(label, didSelectLinkWithURL:href)
    p label
    p href
  end

end
