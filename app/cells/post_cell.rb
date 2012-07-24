class PostCell < UITableViewCell
  def self.createCellWithTableView(tableView, withPost:post)
    tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) || begin
      alloc.initWithFrame([[0,0], [width, height]])
    end
  end

  def self.reuseIdentifier
    to_s
  end

  def self.height
    44
  end

  def self.width
    320
  end

  def initWithFrame(frame)
    if super
      addSubview(mySubview)
    end
    self
  end

  def mySubview
    @mySubview ||= begin
      # define a subview here
    end
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
