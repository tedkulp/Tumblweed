class AudioCell < PostCell

  def height
    75
  end

  def setupSubviewArray
    @blog_name = UILabel.alloc.initWithFrame(CGRectZero)

    [@blog_name]
  end

  def updateViewsFromPost(post)
    @blog_name.frame = [[CELL_PADDING, CELL_PADDING], [150, 20]]
    @blog_name.text = post.blog_name
    @blog_name.setMinimumFontSize(16)
    @blog_name.setFont(UIFont.systemFontOfSize(16))
  end

end
