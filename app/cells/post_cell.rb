class PostCell < UITableViewCell
  attr_accessor :post

  CELL_PADDING = 2
  CELL_WIDTH = 320
  IMAGE_HEIGHT = 50

  def self.createCellWithTableView(tableView, withPost:post)
    cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) || begin
      alloc.initWithFrame([[0,0], [width, height]])
    end
    cell.updateViewsFromPost(post)
    cell
  end

  def self.reuseIdentifier
    to_s
  end

  def self.height
    44
  end

  def height
    self.class.height
  end

  def self.width
    320
  end

  def width
    self.class.width
  end

  def initWithFrame(frame)
    if super
      addSubviews(mySubviews)
    end
    self
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
