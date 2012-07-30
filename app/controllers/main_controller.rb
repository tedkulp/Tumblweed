class MainController < UIViewController

  BAR_WIDTH = 100

  def loadView
    @base_view = UIView.alloc.initWithFrame(CGRectZero)
    @base_view.backgroundColor = UIColor.whiteColor
    @base_view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth

    @button_bar = UIView.alloc.initWithFrame(CGRectZero)
    @button_bar.backgroundColor = UIColor.darkGrayColor
    @button_bar.autoresizingMask = UIViewAutoresizingFlexibleHeight

    @home_button = UIImageView.alloc.initWithImage(UIImage.imageNamed("dark_home"))
    @home_button.frame = [[BAR_WIDTH / 2 - @home_button.image.size.width / 2, 15], [@home_button.image.size.width, @home_button.image.size.height]]
    @button_bar.addSubview(@home_button)

    size = "Dashboard".sizeWithFont(UIFont.systemFontOfSize(12))
    @home_text = UILabel.alloc.init
    @home_text.frame = [[BAR_WIDTH / 2 - size.width / 2, 42], [size.width, size.height]]
    @home_text.text = "Dashboard"
    @home_text.setMinimumFontSize(12)
    @home_text.setFont(UIFont.systemFontOfSize(12))
    @home_text.backgroundColor = UIColor.darkGrayColor
    @home_text.color = UIColor.blackColor
    @button_bar.addSubview(@home_text)

    @base_view.addSubview(@button_bar)

    @content_view = UITableView.alloc.initWithFrame(CGRectZero)
    @content_view.backgroundColor = UIColor.lightGrayColor
    @content_view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
    @content_view.separatorStyle = UITableViewCellSeparatorStyleNone
    @content_view.dataSource = self
    @content_view.delegate = self
    @base_view.addSubview(@content_view)


    self.view = @base_view
  end

  def landscape?
    [:landscape_left, :landscape_right].include? Device.orientation
  end

  def deviceWidth
    landscape? ? Device.screen.height : Device.screen.width
  end

  def deviceHeight
    landscape? ? Device.screen.width : Device.screen.height
  end

  def viewDidLoad
    super

    @base_view.frame = App.delegate.window.bounds
    @button_bar.frame = [[0, 0], [BAR_WIDTH, @base_view.frame.size.height]]
    @content_view.frame = [[BAR_WIDTH, 0], [@base_view.frame.size.width - BAR_WIDTH, @base_view.frame.size.height]]

    p App.delegate.window.bounds
    p @base_view.bounds
    p @content_view.bounds

    @posts = []
    @tumblr = TumblrEngine.alloc.initWithDelegate(self, consumerKey:configToken, consumerSecret:configTokenSecret)

    if @tumblr.isAuthenticated
      @tumblr.getDashboardEntries(lambda { |thing|
      #@tumblr.getBlogEntries('tedkulp.tumblr.com', onComplete:lambda { |thing|
        json = thing.responseString.to_s.objectFromJSONString
        json['response']['posts'].each do |post_data|
          new_post = createPostFromType(post_data['type'], dataHash:post_data)
          @posts << new_post
        end
        @content_view.reloadData
      }, onError:lambda { |err|
        p 'err'
        p err.code
        p err.domain
        p err.userInfo
      })
    else
      @tumblr.authenticateWithCompletionBlock lambda { |something|
        @tumblr.getDashboardEntries(lambda { |thing|
          json = thing.responseString.to_s.objectFromJSONString
          json['response']['posts'].each do |post_data|
            new_post = createPostFromType(post_data['type'], dataHash:post_data)
            @posts << new_post
          end
          @content_view.reloadData
        }, onError:lambda { |err|
          p 'err'
          p err.code
          p err.domain
          p err.userInfo
        })
      }
      @tumblr.authenticateWithUsername('tumblr@wishy.org', password:'B0l1U2m0')
      p 'Not signed in'
    end
  end

  def viewDidUnload
    @tumblr = nil
    super
  end

  def viewWillAppear(animated)
    super
  end

  def viewWillDisappear(animated)
    super
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    true
  end

  #--------

  def configToken
    NSBundle.mainBundle.objectForInfoDictionaryKey('OAuthKeyHash')['token']
  end

  def configTokenSecret
    NSBundle.mainBundle.objectForInfoDictionaryKey('OAuthKeyHash')['tokenSecret']
  end

  #--------

  def createPostFromType(type, dataHash:post_data)
    begin
      klass = Object.const_get(type.capitalize)
    rescue
      # In case there is a new post type we didn't account for.
      # Fall back to the generic Post so we at least show
      # something.
      klass = Object.const_get('Post')
    end
    klass.new(post_data || {})
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @posts.length
  end

  def tableView(tableView, cellForRowAtIndexPath:path)
    getCellForIndexPath(path, withTableView:tableView)
  end

  def tableView(tableView, didSelectRowAtIndexPath:path)
    #@delegate.openURL(@posts[path.row].post_url) if @delegate.respond_to?'openURL'
    #@delegate.openDetailViewFromPost(@posts[path.row])
  end

  def tableView(tableView, heightForRowAtIndexPath:path)
    # getCellForIndexPath(path, withTableView:tableView).height
    height = tableView.rowHeight

    if tableView == @content_view
      cell = self.tableView(tableView, cellForRowAtIndexPath:path)

      if cell.respond_to?('cellHeightForContentWidth:withPost')
        height = cell.cellHeightForContentWidth(tableView.bounds.size.width, withPost:@posts[path.row])
      end
    end

    height
  end

  def getCellForIndexPath(path, withTableView:tableView)
    klass = getClassObjectForIndexPath(path)
    cell = klass.createCellWithTableView(tableView, withPost:@posts[path.row])
    cell.autoresizingMask = UIViewAutoresizingFlexibleWidth
    cell.frame.size.width = @content_view.frame.size.width
    cell.width = @content_view.frame.size.width
    cell
  end

  def getClassObjectForIndexPath(path)
    begin
      klass = Object.const_get(@posts[path.row].class.to_s + 'Cell')
    rescue
      # In case there is a new post type we didn't account for.
      # Fall back to the generic PostCell so we at least show
      # something.
      klass = Object.const_get('PostCell')
    end
    klass
  end

end
