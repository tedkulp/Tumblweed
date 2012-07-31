# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'
Bundler.require

types = ['quote', 'photo', 'audio']

deps = {}

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name          = 'Tumblweed'
  app.identifier    = 'net.shiftrefresh.tumblweed'
  app.device_family = :ipad
  app.frameworks    << 'Security'

  app.pods do
    pod 'RSOAuthEngine'
    pod 'Lockbox'
    pod 'JSONKit'
  end

  app.entitlements['keychain-access-groups'] = [
    app.seed_id + '.' + app.identifier
  ]

  app.info_plist['OAuthKeyHash'] = {
    'token' => 'XDZviJJFTjuPWwHbVybM7pRN05IAEkyCTKlDGAdQYA9zqaKZrL',
    'tokenSecret' => 'T5N6v5LQ9130GIuvjJVK5FgmJqcF2Jj3fj99Xyyk4QH0tYNdYv'
  }

  app.vendor_project('vendor/SDWebImage', :xcode, :headers_dir => 'SDWebImage', :target => 'SDWebImage ARC')
  app.vendor_project('vendor/RichContentLabel/RCLabel', :xcode, :headers_dir => 'RCLabel', :target => 'RCLabelLib')

  types.each do |type|
    app.files_dependencies "./app/models/#{type}.rb" => './app/models/post.rb'
    app.files_dependencies "./app/cells/#{type}_cell.rb" => './app/cells/post_cell.rb'
    app.files_dependencies "./app/views/#{type}_view.rb" => './app/views/post_view.rb'
    app.files_dependencies './app/controllers/subject_controller.rb' => "./app/models/#{type}.rb"
    app.files_dependencies './app/controllers/subject_controller.rb' => "./app/cells/#{type}_cell.rb"
  end

  app.files_dependencies './app/controllers/subject_controller.rb' => './app/models/post.rb'
  app.files_dependencies './app/controllers/subject_controller.rb' => './app/cells/post_cell.rb'
end
