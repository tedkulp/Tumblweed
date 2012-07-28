class AppDelegate
  attr_accessor :detail_nav
  attr_accessor :subject_controller

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    # Setup our custom controllers. One overarching controller
    # and then one for each of the two views that belong to the
    # split
    @main_controller = MainController.alloc.init
    @subject_controller = SubjectController.alloc.init
    @detail_controller = DetailController.alloc.init
    @subject_controller.delegate = @detail_controller #TODO: Change me

    @subject_nav = UINavigationController.alloc.initWithRootViewController(@subject_controller)
    @detail_nav = UINavigationController.alloc.initWithRootViewController(@detail_controller)

    # Setup the split -- not point in making this it's own view
    @split_view_controller = UISplitViewController.alloc.init
    @split_view_controller.delegate = @detail_controller #TODO: Change me
    @split_view_controller.viewControllers = [@subject_nav, @detail_nav]

    @window.rootViewController = @split_view_controller
    @window.makeKeyAndVisible

    true
  end
end
