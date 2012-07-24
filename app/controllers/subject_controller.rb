class SubjectController < UITableViewController
  attr_accessor :delegate

  def viewDidLoad
    @posts = []
    BubbleWrap::HTTP.get("http://api.tumblr.com/v2/blog/tedkulp.tumblr.com/posts?api_key=#{apiKey}&notes_info=true&reblog_info=true") do |response|
      if response.ok?
        json = BubbleWrap::JSON.parse(response.body.to_str)
        json['response']['posts'].each do |post_data|
          new_post = createPostFromType(post_data['type'])
          new_post.text = post_data['text']
          new_post.post_url = post_data['post_url']
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

  def createPostFromType(type)
    begin
      klass = Object.const_get(type.capitalize)
    rescue
      # In case there is a new post type we didn't account for.
      # Fall back to the generic Post so we at least show
      # something.
      klass = Object.const_get('Post')
    end
    klass.new
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
    klass = getClassObjectForIndexPath(path)
    klass.createCellWithTableView(tableView, withPost:@posts[path.row])
  end

  def tableView(tableView, didSelectRowAtIndexPath:path)
    @delegate.openURL(@posts[path.row].post_url) if @delegate.respond_to?'openURL'
  end

  def tableView(tableView, heightForRowAtIndexPath:path)
    getClassObjectForIndexPath(path).height
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
