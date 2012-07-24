class SubjectController < UITableViewController
  attr_accessor :delegate

  def viewDidLoad
    @posts = []
    BubbleWrap::HTTP.get("http://api.tumblr.com/v2/blog/tedkulp.tumblr.com/posts?api_key=#{apiKey}&notes_info=true&reblog_info=true") do |response|
      if response.ok?
        json = BubbleWrap::JSON.parse(response.body.to_str)
        json['response']['posts'].each do |post_data|
          new_post = Post.new
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

  def apiKey
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
    cell = tableView.dequeueReusableCellWithIdentifier("cell") || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:"cell")
    cell.textLabel.text = @posts[path.row].text
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:path)  
    @delegate.openURL(@posts[path.row].post_url) if @delegate.respond_to?'openURL'
  end
end
