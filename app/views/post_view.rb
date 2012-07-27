class PostView < UIView

  def self.createPostViewFromPost(post)
    begin
      klass = Object.const_get(post.class.to_s + 'View')
    rescue
      klass = Object.const_get('PostView')
    end
    klass.alloc.initWithFrame(CGRectZero, withPost:post)
  end

  def initWithFrame(frame, withPost:post)
    if super.initWithFrame(frame)
      @post = post
    end
    self
  end

  def displayContent
    #override me
    #TODO: Some generic display (or maybe a web view?)
  end

end
