class DetailController < UIViewController
  attr_accessor :popoverViewController

  def viewWillAppear(animated)
    self.navigationController.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Select", style:UIBarButtonItemStyleBordered , target:self, action:'select')
    # @webView = UIWebView.alloc.initWithFrame(self.view.bounds)
    # @webView.alpha = 0
    # @webView.delegate = self
    # self.view.addSubview(@webView)

    # @activityIndicator = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleGray)
    # @activityIndicator.center = self.view.center
  end

  def shouldAutorotateToInterfaceOrientation(*)
    true
  end

  def splitViewController(svc, willHideViewController:vc, withBarButtonItem:barButtonItem, forPopoverController:pc)
    barButtonItem.title = "Posts"
    self.navigationItem.setLeftBarButtonItem(barButtonItem)
    self.popoverViewController = pc
  end

  def splitViewController(svc, willShowViewController:avc, invalidatingBarButtonItem:barButtonItem)
    self.navigationItem.setLeftBarButtonItems([], animated:false)
    self.popoverViewController = nil
  end

  def openDetailViewFromPost(post)
    self.view = PostView.createPostViewFromPost(post)
    self.view.backgroundColor = UIColor.whiteColor
    self.view.displayContent
  end

  # def openURL(url)
  #   if !(/http:\/\/(.*)\// =~ url)
  #     url = "http://" + url + "/"
  #   end

  #   UIView.animateWithDuration(0.5, animations: -> do
  #     @webView.alpha = 0
  #   end
  #   )

  #   @webView.loadRequest(NSURLRequest.requestWithURL(NSURL.URLWithString(url)))
  #   if self.popoverViewController
  #     self.popoverViewController.dismissPopoverAnimated(true)
  #   end
  # end

  # def webViewDidStartLoad(webview)
  #   @activityIndicator.startAnimating
  # end

  # def webViewDidFinishLoad(webview)
  #   @activityIndicator.stopAnimating
  #   UIView.animateWithDuration(0.5, animations: -> do
  #     @webView.alpha = 1
  #   end)
  # end
end
