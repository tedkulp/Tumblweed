class QuoteCell < PostCell

  def height
    75
  end

  def setupSubviewArray
    view_a = UIView.alloc.initWithFrame([[0, 0], [25, 25]])
    view_a.backgroundColor = UIColor.greenColor

    view_b = UIView.alloc.initWithFrame([[25, 0], [25, 25]])
    view_b.backgroundColor = UIColor.redColor
    [view_a, view_b]
  end

  def updateViewsFromPost(post)
    #TODO: Add quote-y type stuff here
  end

end
