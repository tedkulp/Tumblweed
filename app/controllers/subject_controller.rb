class SubjectController < UITableViewController
  attr_accessor :delegate

  def viewDidLoad
    @posts = []
    # p "here"

    # @responseData = NSMutableData.data

    # request = NSURLRequest.requestWithURL(NSURL.URLWithString("http://api.tumblr.com/v2/blog/tedkulp.tumblr.com/posts?api_key=#{apiKey}&notes_info=true&reblog_info=true"))
    # NSURLConnection.alloc.initWithRequest(request, delegate:self)
    BubbleWrap::HTTP.get("http://api.tumblr.com/v2/blog/tedkulp.tumblr.com/posts?api_key=#{apiKey}&notes_info=true&reblog_info=true", {}) do |response|
      if response.ok?
        json = BubbleWrap::JSON.parse(response.body.to_str)
        json['response']['posts'].each do |post_data|
          new_post = createPostFromType(post_data['type'], dataHash:post_data)
          @posts << new_post
        end
        tableView.reloadData
      elsif response.status_code.to_s =~ /40\d/
        App.alert("Login failed")
      else
        App.alert(response.error_message)
      end
    end
  end

  # def connection(connection, didReceiveResponse:response)
  #   @responseData.setLength(0)
  # end

  # def connection(connection, didReceiveData:data)
  #   @responseData.appendData(data)
  # end

  # def connection(connection, didFailWithError:error)
  #   @responseData = nil
  # end

  # def connectionDidFinishLoading(connection)
  #   unless @responseData.nil?
  #     responseString = NSString.alloc.initWithData(@responseData, encoding:NSUTF8StringEncoding)

  #     p responseString.to_s
  #     json = BubbleWrap::JSON.parse(responseString.to_s)
  #     json['response']['posts'].each do |post_data|
  #       new_post = createPostFromType(post_data['type'], dataHash:post_data)
  #       @posts << new_post
  #     end
  #     tableView.reloadData

  #     @responseData = nil
  #   end
  # end

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

  def apiKey
    #TODO: WTF? Move me!
    "XDZviJJFTjuPWwHbVybM7pRN05IAEkyCTKlDGAdQYA9zqaKZrL"
  end

  def shouldAutorotateToInterfaceOrientation(*)
    true
  end

  def numberOfSectionsInTableView(tableView)
    1
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
