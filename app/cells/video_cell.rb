class VideoCell < PostCell

  def height
    80
  end

  def setupSubviewArray
    @caption = RCLabel.alloc.initWithFrame(CGRectZero)
    @web_view = UIWebView.alloc.initWithFrame(CGRectZero)

    super + [@caption, @web_view]
  end

  def prepareForReuse
    @caption.componentsAndPlainText = RCLabel.extractTextStyle('')
  end

  def updateViewsFromPost(post)
    super

    unless post.caption.empty?
      width = 500
      height = 300

      if post.player.last['embed_code']
        # Take a stab at trying to get the height and width
        # from the embed code. If not, then we'll make assumptions
        if width_found = post.player.last['embed_code'].scan(/width=\"([0-9]+)\"/)
          begin
            width = width_found[0][0].to_i
          rescue
            width = 500
          end
        end

        if height_found = post.player.last['embed_code'].scan(/height=\"([0-9]+)\"/)
          begin
            height = height_found[0][0].to_i
          rescue
            height = 300
          end
        end

        p embedHtml(post.player.last['embed_code'])
        @web_view.loadHTMLString(embedHtml(post.player.last['embed_code']), baseURL:nil)
        @web_view.setOpaque(false)
        @web_view.setBackgroundColor(UIColor.clearColor)
        @web_view.scrollView.scrollEnabled = false
        @web_view.scrollView.bounces = false
        @web_view.delegate = self
        @web_view.frame = [[self.frame.size.width / 2 - width / 2, 70], [width, height]]
        @web_view.allowsInlineMediaPlayback = true
        @web_view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
      end

      text = "<html><head></head><body  text=\"#333\" link=\"#0000aa\" style=\"background-color: transparent; font-family: Helvetica; font-size:14px; text-align:center;\">#{post.caption}</body></html>"
      @caption.componentsAndPlainText = RCLabel.extractTextStyle(text)
      @caption.setOpaque(false)
      @caption.setBackgroundColor(UIColor.clearColor)
      @caption.textAlignment = KCTCenterTextAlignment
      @caption.delegate = self
      @caption.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin

      opt_size = @caption.optimumSize
      @caption.frame = [[self.frame.size.width / 2 - width / 2, height + 70], [width, opt_size.height]]
    end
  end

  def embedHtml(iframe_code)
    "<html><head></head><body style=\"margin: 0; padding: 0;\">#{iframe_code.gsub('\"', '"')}</body></html>"
  end

end
