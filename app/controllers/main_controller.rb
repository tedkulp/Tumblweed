class MainController < UISplitViewController

  def splitViewController(svc,
                          willHideViewController:aViewController,
                          withBarButtonItem:barButtonItem,
                          forPopoverController:pc)
    barButtonItem.setTitle("List View")
    navigationItem.leftBarButtonItem = barButtonItem
  end

  def splitViewController(svc,
                          willShowViewController:aViewController,
                          invalidatingBarButtonItem:barButtonItem)
    navigationItem.leftBarButtonItem = nil
  end

end
