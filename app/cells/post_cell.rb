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
    }.max
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
    #TODO: Some kind of generic display
  end

  def prepareForReuse
    #Not sure if we'll need this later
  end

  def updateViewsFromPost(post)
    #TODO: Fill in said generic display
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
end
