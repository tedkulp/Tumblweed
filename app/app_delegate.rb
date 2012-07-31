class AppDelegate
  attr_accessor :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    UIFont.familyNames.each do |family_name|
      puts "Family: #{family_name}"
      p UIFont.fontNamesForFamilyName(family_name)
    end

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    # Setup our custom controllers. One overarching controller
    # and then one for each of the two views that belong to the
    # split
    @main_controller = MainController.alloc.init
    #@main_controller.view.frame = @window.bounds

    @window.rootViewController = @main_controller
    @window.makeKeyAndVisible

    true
  end
end
