class PhotoCell < PostCell

  def height
    75
  end

  def setupSubviewArray
    @img = UIImageView.alloc.initWithFrame([[0, 0], [75, 75]])
    [@img]
  end

  def updateViewsFromPost(post)
    @img.image = UIImage.imageWithData(NSData.dataWithContentsOfURL(NSURL.URLWithString(post.photos[0]['alt_sizes'].last['url'])))
  end

end
