class SubjectController < UITableViewController
  attr_accessor :delegate
  attr_accessor :tumblr

  def viewDidLoad
    super

    @posts = []
    @tumblr = TumblrEngine.alloc.initWithDelegate(self, consumerKey:configToken, consumerSecret:configTokenSecret)

    if @tumblr.isAuthenticated
      @tumblr.getDashboardEntries(lambda { |thing|
        json = thing.responseString.to_s.objectFromJSONString
        json['response']['posts'].each do |post_data|
          new_post = createPostFromType(post_data['type'], dataHash:post_data)
          @posts << new_post
        end
        tableView.reloadData
      }, onError:lambda { |err|
        p 'err'
        p err.code
        p err.domain
        p err.userInfo
      })
    else
      @tumblr.authenticateWithCompletionBlock lambda { |something|
        @tumblr.getDashboardEntries(lambda { |thing|
          p thing
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

  def shouldAutorotateToInterfaceOrientation(*)
    true
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tumblrEngineNeedsAuthentication(engine)
    p 'needs auth'
  end

  def tumblrEngine(engine, statusUpdate:message)
    p 'status update: ' + message
  end

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

  def configToken
    NSBundle.mainBundle.objectForInfoDictionaryKey('OAuthKeyHash')['token']
  end

  def configTokenSecret
    NSBundle.mainBundle.objectForInfoDictionaryKey('OAuthKeyHash')['tokenSecret']
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @posts.length
  end

  def tableView(tableView, cellForRowAtIndexPath:path)
    getCellForIndexPath(path)
  end

  def tableView(tableView, didSelectRowAtIndexPath:path)
    #@delegate.openURL(@posts[path.row].post_url) if @delegate.respond_to?'openURL'
    @delegate.openDetailViewFromPost(@posts[path.row])
  end

  def tableView(tableView, heightForRowAtIndexPath:path)
    getCellForIndexPath(path).height
  end

  def getCellForIndexPath(path)
    klass = getClassObjectForIndexPath(path)
    klass.createCellWithTableView(tableView, withPost:@posts[path.row])
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
