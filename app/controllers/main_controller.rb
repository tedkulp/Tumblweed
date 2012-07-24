class MainController < UISplitViewController

  def splitViewController(svc,
                          willHideViewController:aViewController,
                          withBarButtonItem:barButtonItem,
                          forPopoverController:pc)
    barButtonItem.setTitle("List View")
    NSLog("%@", barButtonItem)
    NSLog("willHideViewController")
    navigationItem.leftBarButtonItem = barButtonItem
  end

  def splitViewController(svc,
                          willShowViewController:aViewController,
                          invalidatingBarButtonItem:barButtonItem)
    navigationItem.leftBarButtonItem = nil
    NSLog("%@", barButtonItem)
    NSLog("willShowViewController")
  end

end
