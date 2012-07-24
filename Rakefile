# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'
Bundler.require

types = ['quote', 'photo']

deps = {}

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name          = 'Tumblweed'
  app.identifier    = 'net.shiftrefresh.tumblweed'
  app.device_family = :ipad

  types.each do |type|
    app.files_dependencies "./app/models/#{type}.rb" => './app/models/post.rb'
    app.files_dependencies "./app/cells/#{type}_cell.rb" => './app/cells/post_cell.rb'
    app.files_dependencies './app/controllers/subject_controller.rb' => "./app/models/#{type}.rb"
    app.files_dependencies './app/controllers/subject_controller.rb' => "./app/cells/#{type}_cell.rb"
  end

  app.files_dependencies './app/controllers/subject_controller.rb' => './app/models/post.rb'
  app.files_dependencies './app/controllers/subject_controller.rb' => './app/cells/post_cell.rb'
end
